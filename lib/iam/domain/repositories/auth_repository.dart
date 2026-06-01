import 'package:restock/iam/domain/entities/auth.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepository {
  /// Signs in a user with the given [email] and [password].
  Future<Auth> signIn({
    required String email,
    required String password,
  });
}