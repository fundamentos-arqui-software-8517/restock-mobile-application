import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:restock/communications/infrastructure/models/push_subscription_request.dart';
import 'package:restock/communications/infrastructure/repositories/constants/communications_api_constants.dart';
import 'package:restock/iam/infrastructure/interceptor/auth_http_client.dart';
import 'package:restock/shared/infrastructure/repositories/constants/api_constants.dart';

class PushSubscriptionRemoteDataProvider {
  const PushSubscriptionRemoteDataProvider({required this.http});

  final AuthHttpClient http;

  Future<void> register(PushSubscriptionRequest request) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${CommunicationsApiConstants.pushSubscriptions}',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created ||
        response.statusCode == HttpStatus.noContent) {
      return;
    }

    throw Exception(
      'Failed to register push subscription: ${response.statusCode} ${response.body}',
    );
  }
}
