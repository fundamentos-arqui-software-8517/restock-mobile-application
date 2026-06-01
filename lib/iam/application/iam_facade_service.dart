import 'package:restock/iam/domain/entities/auth.dart';
import 'package:restock/iam/domain/repositories/auth_repository.dart';
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Facade service for authentication operations.
class AuthFacadeService {
  const AuthFacadeService({
    required this.authRepository,
    required this.tokenStorage,
    required this.authStatusNotifier,
  });

  final AuthRepository authRepository;
  final TokenStorage tokenStorage;
  final AuthStatusNotifier authStatusNotifier;

  /// Signs in a user with the given [email] and [password].
  Future<Auth> signIn({required String email, required String password}) async {
    try {
      final authenticatedUser = await authRepository.signIn(
        email: email,
        password: password,
      );

      await tokenStorage.save(
        authenticatedUser.token,
        authenticatedUser.accountId,
        userId: authenticatedUser.id,
      );
      
      authStatusNotifier.onSignInSuccess();

      return authenticatedUser;
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}
