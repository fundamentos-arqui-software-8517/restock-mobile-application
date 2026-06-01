import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:restock/iam/infrastructure/models/sign_in_request.dart';
import 'package:restock/iam/infrastructure/models/sign_in_response.dart';
import 'package:restock/shared/infrastructure/constants/api_constants.dart';

/// Remote data provider for authentication operations.
class AuthRemoteDataProvider {

  /// Signs in a user with the given [request].
  Future<SignInResponse> signIn(SignInRequest request) async {
    try {
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}auth/sign-in');

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        return SignInResponse.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to sign in: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }
}