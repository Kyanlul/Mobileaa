import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  get success => null;

  bool get isLoading => false;

  get error => "";

  /// Check if user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  /// Get current user's email
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is badly formatted.';
      } else if (e.code == 'user-disabled') {
        throw 'This user account has been disabled.';
      }
      throw e.message ?? 'An error occurred during sign in';
    }
  }

  /// Sign up with email and password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    // required CustomUser userModel,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        throw 'The email address is badly formatted.';
      } else if (e.code == 'operation-not-allowed') {
        throw 'Email/password accounts are not enabled.';
      }
      throw e.message ?? 'An error occurred during sign up';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'An error occurred while signing out';
    }
  }

  ///anonymous login
  Future<UserCredential> signInAnonymous() async {
    try {
      final credential = await _auth.signInAnonymously();
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during signin anonymous';
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw 'The email address is badly formatted.';
      } else if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      }
      throw e.message ?? 'An error occurred while resetting password';
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'No user is currently signed in.';
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'requires-recent-login') {
        throw 'This operation requires recent authentication. Please log in again.';
      }
      throw e.message ?? 'An error occurred while updating password';
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'No user is currently signed in.';
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw 'This operation requires recent authentication. Please log in again.';
      }
      throw e.message ?? 'An error occurred while deleting account';
    }
  }

  sendPasswordResetEmail(String email) {}
}
