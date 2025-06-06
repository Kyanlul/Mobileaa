// import '../../../core/app_export.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled/data/models/selection_popup_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/sign_up_model.dart';
//
// class SignUpProvider with ChangeNotifier {
//   final SignUpModel _model = SignUpModel();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // State variables
//   bool _isLoading = false;
//   String _error = '';
//   String _selectedNationality = 'Vietnam';
//   String _selectedGender = 'Male';
//   String _selectedSeller = 'Seller';
//   String _selectedAddress = 'Ha Noi';
//   bool _acceptedTerms = false;
//   bool _acceptedMarketing = false;
//
//   // Getters
//   bool get isLoading => _isLoading;
//   String get error => _error;
//   String get selectedNationality => _selectedNationality;
//   String get selectedGender => _selectedGender;
//   String get selectedSeller => _selectedSeller;
//   String get selectedAddress => _selectedAddress;
//   bool get acceptedTerms => _acceptedTerms;
//   bool get acceptedMarketing => _acceptedMarketing;
//   List<SelectionPopupModel> get nationalityList => _model.nationalityList;
//   List<SelectionPopupModel> get genderList => _model.genderList;
//
//   // Setters
//   void setNationality(String nationality) {
//     _selectedNationality = nationality;
//     notifyListeners();
//   }
//
//   void setGender(String gender) {
//     _selectedGender = gender;
//     notifyListeners();
//   }
//
//   void setAcceptedTerms(bool value) {
//     _acceptedTerms = value;
//     notifyListeners();
//   }
//
//   void setAcceptedMarketing(bool value) {
//     _acceptedMarketing = value;
//     notifyListeners();
//   }
//
//   // Validation methods
//   String? validateEmail(String? email) {
//     return _model.validateEmail(email);
//   }
//
//   String? validatePassword(String? password) {
//     return _model.validatePassword(password);
//   }
//
//   String? validateConfirmPassword(String? password, String? confirmPassword) {
//     return _model.validateConfirmPassword(password, confirmPassword);
//   }
//
//   // Sign Up Method
//   Future<bool> signUp({
//     required String email,
//     required String password,
//     required String firstName,
//     required String lastName,
//   }) async {
//     // Reset previous states
//     _isLoading = true;
//     _error = '';
//     notifyListeners();
//
//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       // Save additional user details to Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'nationality': _selectedNationality,
//         'gender': _selectedGender,
//         'acceptedTerms': _acceptedTerms,
//         'acceptedMarketing': _acceptedMarketing,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } on FirebaseAuthException catch (e) {
//       _error = _handleFirebaseAuthError(e);
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     } catch (e) {
//       _error = 'An unexpected error occurred';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//
//   // Error handling method
//   String _handleFirebaseAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'weak-password':
//         return 'The password is too weak';
//       case 'email-already-in-use':
//         return 'An account already exists with this email';
//       case 'invalid-email':
//         return 'Invalid email address';
//       default:
//         return 'Sign up failed. Please try again.';
//     }
//   }
//
//   // Clear any existing errors
//   void clearError() {
//     _error = '';
//     notifyListeners();
//   }
// }