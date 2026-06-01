import 'package:restock/iam/domain/entities/auth.dart';

/// Model class representing the authentication response from the API.
class SignInResponse {
  const SignInResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.token,
    required this.accountId,
  });

  final String id;
  final String email;
  final String role;
  final String token;
  final String accountId;

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
      accountId: json['accountId'],
    );
  }

  Auth toDomain() {
    return Auth(id: id, email: email, role: role, token: token, accountId: accountId);
  }
}
