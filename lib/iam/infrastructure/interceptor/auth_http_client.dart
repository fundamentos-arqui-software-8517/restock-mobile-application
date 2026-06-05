// lib/shared/infrastructure/http/auth_http_client.dart
import 'package:http/http.dart' as http;
import 'package:restock/shared/infrastructure/services/auth_status_notifier.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Custom HTTP client that automatically adds the authentication token to requests and handles unauthorized responses.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient({
    required this.tokenStorage,
    required this.authStatusNotifier,
    http.Client? inner,
  }) : _inner = inner ?? http.Client();

  final TokenStorage tokenStorage;
  final AuthStatusNotifier authStatusNotifier;
  final http.Client _inner;

  /// Overrides the send method to add the authentication token to the request headers and handle unauthorized responses. 
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await tokenStorage.readToken();

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final response = await _inner.send(request);

    if (response.statusCode == 401) {
      await authStatusNotifier.signOut();
    }

    return response;
  }
}