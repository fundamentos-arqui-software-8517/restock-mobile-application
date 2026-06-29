import 'dart:io';

/// This file contains constants related to the API endpoints used in the application.
class ApiConstants {

  static const String _productionUrl = String.fromEnvironment('API_BASE_URL');

  /// The base URL for Android and IOS Simulator (localhost).
  static String get baseUrl {

    if (_productionUrl.isNotEmpty) {
      return _productionUrl;
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1/';
    }
    return 'http://127.0.0.1:8080/api/v1/';
  }
}
