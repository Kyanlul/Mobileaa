class ForgotPasswordModel {
  final String email;
  final String? errorText;

  ForgotPasswordModel({
    required this.email,
    this.errorText,
  });

  ForgotPasswordModel copyWith({
    String? email,
    String? errorText,
  }) {
    return ForgotPasswordModel(
      email: email ?? this.email,
      errorText: errorText ?? this.errorText,
    );
  }
}