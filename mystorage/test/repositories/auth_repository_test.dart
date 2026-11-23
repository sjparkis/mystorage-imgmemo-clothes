import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mystorage/data/repositories/auth_repository.dart';

@GenerateMocks([GoTrueClient])
import 'auth_repository_test.mocks.dart';

void main() {
  group('AuthRepository', () {
    late MockGoTrueClient mockAuth;
    late AuthRepository repo;

    setUp(() {
      mockAuth = MockGoTrueClient();
      repo = AuthRepository(auth: mockAuth);
    });

    test('signIn calls auth with email and password', () async {
      when(mockAuth.signInWithPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => AuthResponse());

      await repo.signIn(email: 'test@test.com', password: '123456');

      verify(mockAuth.signInWithPassword(
        email: 'test@test.com',
        password: '123456',
      )).called(1);
    });

    test('signOut calls auth.signOut', () async {
      when(mockAuth.signOut()).thenAnswer((_) async {});
      await repo.signOut();
      verify(mockAuth.signOut()).called(1);
    });
  });
}
