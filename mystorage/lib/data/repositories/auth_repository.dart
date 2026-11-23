import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final GoTrueClient _auth;

  AuthRepository({GoTrueClient? auth})
      : _auth = auth ?? Supabase.instance.client.auth;

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp({required String email, required String password}) async {
    await _auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;
}
