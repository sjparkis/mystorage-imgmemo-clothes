import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';

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

sealed class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
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
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        await _repo.signUp(email: event.email, password: event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthSignOut>((_, emit) async {
      await _repo.signOut();
      emit(AuthInitial());
    });
  }
}
