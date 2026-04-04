import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usersKey = 'users';
  static const _loggedInKey = 'loggedInUser';

  Future<String?> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    final Map<String, dynamic> users =
        raw != null ? jsonDecode(raw) : {};

    if (users.containsKey(username)) {
      return 'Username already exists.';
    }
    users[username] = password;
    await prefs.setString(_usersKey, jsonEncode(users));
    return null;
  }

  Future<String?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    final Map<String, dynamic> users =
        raw != null ? jsonDecode(raw) : {};

    if (!users.containsKey(username)) {
      return 'User not found.';
    }
    if (users[username] != password) {
      return 'Incorrect password.';
    }
    await prefs.setString(_loggedInKey, username);
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedInKey);
  }
}