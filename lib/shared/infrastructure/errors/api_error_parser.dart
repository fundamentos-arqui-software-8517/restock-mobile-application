import 'dart:convert';

class ApiErrorParser {
  const ApiErrorParser._();

  static String parse(Object error, {String fallback = 'An error occurred'}) {
    final raw = error.toString();
    final jsonStart = raw.indexOf('{');
    final jsonEnd = raw.lastIndexOf('}');

    if (jsonStart >= 0 && jsonEnd > jsonStart) {
      final message = _messageFromJson(raw.substring(jsonStart, jsonEnd + 1));
      if (message != null) return message;
    }

    final cleaned = raw
        .replaceAll('Exception: ', '')
        .replaceAll(RegExp(r'Failed to [^:]+: '), '')
        .trim();

    return cleaned.isEmpty ? fallback : cleaned;
  }

  static String? _messageFromJson(String jsonText) {
    try {
      final decoded = jsonDecode(jsonText);
      if (decoded is! Map<String, dynamic>) return null;

      final message = decoded['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        return message;
      }

      final error = decoded['error']?.toString();
      if (error != null && error.trim().isNotEmpty) {
        return error;
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
