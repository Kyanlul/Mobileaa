// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:untitled/model/user.dart';
// import 'package:untitled/services/Database/product_service.dart';
//
// class AuthNotifier extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//   String? error;
//   String? success;
//
//   // create user obj custom from FireBaseUser
//   CustomUser? _userFromFirebaseUser(User? user) {
//     return user != null ? CustomUser(uid: user.uid) : null;
//   }
//
//   // auth change user stream
//   Stream<CustomUser?> get user {
//     return _auth.authStateChanges().map(_userFromFirebaseUser);
//   }
//
//   // sign in anon
//   Future signInAnon() async {
//     try {
//       setLoading(true);
//       UserCredential credential = await _auth.signInAnonymously();
//       User? user = credential.user;
//       setLoading(false);
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       setLoading(false);
//       error = e.toString();
//       notifyListeners();
//       return null;
//     }
//   }
//
//   // sign out
//   Future signOut() async {
//     try {
//       setLoading(true);
//       await _auth.signOut();
//       setLoading(false);
//       return;
//     } catch (e) {
//       setLoading(false);
//       error = e.toString();
//       notifyListeners();
//       return null;
//     }
//   }
//
//   // sign in with auth
//   Future signInWithEmailPass(String email, String password) async {
//     try {
//       setLoading(true);
//       UserCredential res = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       User? user = res.user;
//       setLoading(false);
//       success = "SignIn success !";
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       setLoading(false);
//       error = e.toString();
//       notifyListeners();
//       return null;
//     }
//   }
//
//   //Register with email
//   Future registerWithEmail(String email, String password) async {
//     try {
//       setLoading(true);
//       UserCredential res = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       User? user = res.user;
//       String name = email.split('@')[0];
//       // await DatabaseService(uid: user!.uid).updateUserData(email, name, 0);
//       setLoading(false);
//       success = "Register success !";
//       return _userFromFirebaseUser(user);
//     } catch (e) {
//       setLoading(false);
//       if (e is FirebaseAuthException) {
//         if (e.code == 'email-already-in-use') {
//           error = 'This email is already registered';
//         } else if (e.code == 'channel-error') {
//           error = "Please fill in the missing box";
//         }
//       } else {
//         error = e.toString();
//       }
//       notifyListeners();
//       return null;
//     }
//   }
//
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       print('Password reset email sent.');
//       success = 'Reset link sent! Please check your email.';  // Cập nhật thông báo thành công
//       notifyListeners();
//     } catch (e) {
//       print('Error sending password reset email: $e');
//       setError('Failed to send reset link. Please try again.');  // Cập nhật thông báo lỗi
//     }
//   }
//
//   void setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }
//
//   void clearError() {
//     error = null;
//     notifyListeners();
//   }
//
//   void setError(String errorMessage) {
//     error = errorMessage;
//     notifyListeners(); // Để các widget lắng nghe và cập nhật khi có lỗi
//   }
// }
