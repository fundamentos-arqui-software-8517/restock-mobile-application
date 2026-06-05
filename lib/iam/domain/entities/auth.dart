/// Represents the authenticated user entity.
class Auth {
  const Auth({
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
}