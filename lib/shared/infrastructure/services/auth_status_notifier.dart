// lib/shared/infrastructure/services/auth_status_notifier.dart
import 'package:flutter/material.dart';
import 'package:restock/shared/infrastructure/storage/token_storage.dart';

/// Notifier for authentication status. It listens for changes in the authentication state and notifies listeners accordingly.
class AuthStatusNotifier extends ChangeNotifier {
  AuthStatusNotifier({required TokenStorage tokenStorage})
    : _tokenStorage = tokenStorage;

  final TokenStorage _tokenStorage;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  /// Initializes the authentication status by checking if a token is stored. If a token exists, it sets the authentication status to true and notifies listeners.
  Future<void> initialize() async {
    final token = await _tokenStorage.readToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  /// Updates the authentication status to true and notifies listeners. This should be called after a successful sign-in.
  void onSignInSuccess() {
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Updates the authentication status to false and notifies listeners. This should be called when the user logs out.
  Future<void> signOut() async {
    await _tokenStorage.delete();
    _isAuthenticated = false;
    notifyListeners();
  }
}
