import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  String _toEmail(String username) => '$username@noteease.app';

  Future<bool> validateUserName(String username) async {
    final snapshot = await _db.child('username/$username').get();
    if (snapshot.exists) return true;
    return false;
  }

  Future createCredential(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future saveNewUser(String username, String uid) async {
    await _db.child('username/$username').set({'uid': uid});
    await _db.child('users/$uid').set({
      'email': _toEmail(username),
      'username': username,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future createAuth(String username, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: _toEmail(username),
      password: password,
    );
  }

  String _mapError(String code) {
    switch (code) {
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password.';
      case 'user-not-found':
        return 'User not found.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  Future<String?> register(String username, String password) async {
    try {
      final validateusername = await validateUserName(username);

      if (validateusername) return 'Username already exists.';

      final credentials = await createCredential(_toEmail(username), password);

      final uid = credentials.user!.uid;

      await saveNewUser(username, uid);

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      debugPrint('REGISTRATION ERROR: $e');
      return "Something went wrong. Please try again.";
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      final validateuser = await validateUserName(username);
      if (!validateuser) return "User not found.";

      await createAuth(username, password);

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapError(e.code);
    } catch (e) {
      return "Something went wrong. Please try again later.";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<String?> getLoggedInUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _db.child('users/${user.uid}/username').get();
    return snapshot.value as String?;
  }

  bool get isLoggedIn => _auth.currentUser != null;
}
