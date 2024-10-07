import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  AuthProvider() {
    // Automatically check if the user is logged in when the provider is initialized
    _loadTokenFromStorage();
  }

  // Load token from SharedPreferences to handle auto-login
  Future<void> _loadTokenFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    if (storedToken != null && storedToken.isNotEmpty) {
      _token = storedToken;
      _isLoggedIn = true;
      notifyListeners(); // Notify the UI that the user is logged in
    }
  }

  // Save token and login the user
  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token); // Save token to SharedPreferences
    _token = token;
    _isLoggedIn = true;
    notifyListeners(); // Notify the UI that the user is logged in
  }

  // Log out the user by clearing the token and session data
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove token from SharedPreferences
    _token = null;
    _isLoggedIn = false;
    notifyListeners(); // Notify the UI that the user is logged out
  }
}
