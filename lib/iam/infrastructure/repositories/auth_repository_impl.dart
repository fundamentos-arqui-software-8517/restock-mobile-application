import 'package:restock/iam/domain/entities/auth.dart';
import 'package:restock/iam/domain/repositories/auth_repository.dart';
import 'package:restock/iam/infrastructure/data_sources/auth_remote_data_provider.dart';
import 'package:restock/iam/infrastructure/models/sign_in_request.dart';

/// Implementation of [AuthRepository] using the remote data provider.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required this.authRemoteDataProvider});

  final AuthRemoteDataProvider authRemoteDataProvider;

  @override
  Future<Auth> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final request = SignInRequest(email: email, password: password);
      final response = await authRemoteDataProvider.signIn(request);
      return response.toDomain();
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }
}