import 'package:flutter/material.dart';
import '../models/forgot_password_model.dart';

class ForgotPasswordProvider with ChangeNotifier {
  ForgotPasswordModel _model = ForgotPasswordModel(email: '');

  ForgotPasswordModel get model => _model;

  bool validateEmail(String email) {
    if (email.isEmpty) {
      _model = _model.copyWith(errorText: 'Email is required');
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(email)) {
      _model = _model.copyWith(errorText: 'Invalid email address');
      notifyListeners();
      return false;
    }

    _model = _model.copyWith(email: email, errorText: null);
    notifyListeners();
    return true;
  }

  Future<bool> sendPasswordResetEmail(BuildContext context) async {
    try {
      return true;
    } catch (e) {
      _model = _model.copyWith(errorText: 'Failed to send reset link');
      notifyListeners();
      return false;
    }
  }
}