import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/storage_repository.dart';

sealed class AuthEvent {}

class AuthSignIn extends AuthEvent {
  final String email, password;
  AuthSignIn(this.email, this.password);
}

class AuthSignUp extends AuthEvent {
  final String email, password;
  AuthSignUp(this.email, this.password);
}

class AuthSignOut extends AuthEvent {}

enum AuthErrorCode {
  required,
  passwordTooShort,
  invalidCredentials,
  emailInUse,
  invalidInput,
  network,
  unknown,
}

sealed class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthEmailVerificationSent extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  final AuthErrorCode code;
  AuthFailure(this.message, {this.code = AuthErrorCode.unknown});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        await _repo.signIn(email: event.email, password: event.password);
        emit(AuthSuccess());
      } catch (e) {
        debugPrint('[AuthBloc] signIn error: $e');
        emit(_parseAuthFailure(e));
      }
    });

    on<AuthSignUp>((event, emit) async {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthFailure('이메일과 비밀번호를 입력해 주세요.',
            code: AuthErrorCode.required));
        return;
      }
      if (event.password.length < 6) {
        emit(AuthFailure('비밀번호는 6자 이상이어야 합니다.',
            code: AuthErrorCode.passwordTooShort));
        return;
      }
      emit(AuthLoading());
      try {
        final session =
            await _repo.signUp(email: event.email, password: event.password);
        debugPrint('[AuthBloc] signUp success, session: ${session != null}');
        if (session != null) {
          emit(AuthSuccess());
        } else {
          emit(AuthEmailVerificationSent());
        }
      } catch (e) {
        debugPrint('[AuthBloc] signUp error: $e');
        emit(_parseAuthFailure(e));
      }
    });

    on<AuthSignOut>((_, emit) async {
      StorageRepository.clearCache();
      await _repo.signOut();
      emit(AuthInitial());
    });
  }

  AuthFailure _parseAuthFailure(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid_credentials')) {
      return AuthFailure('이메일 또는 비밀번호가 올바르지 않습니다.',
          code: AuthErrorCode.invalidCredentials);
    }
    if (msg.contains('email already registered') ||
        msg.contains('already registered')) {
      return AuthFailure('이미 사용 중인 이메일입니다.',
          code: AuthErrorCode.emailInUse);
    }
    if (msg.contains('password') &&
        (msg.contains('least') || msg.contains('short'))) {
      return AuthFailure('비밀번호는 6자 이상이어야 합니다.',
          code: AuthErrorCode.passwordTooShort);
    }
    if (msg.contains('422')) {
      return AuthFailure('입력 정보를 확인해 주세요. (비밀번호 6자 이상)',
          code: AuthErrorCode.invalidInput);
    }
    if (msg.contains('network') || msg.contains('connection')) {
      return AuthFailure('네트워크 연결을 확인해 주세요.',
          code: AuthErrorCode.network);
    }
    return AuthFailure(e.toString());
  }
}
