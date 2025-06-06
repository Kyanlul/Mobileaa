/// Checks if the given string is a valid email address.
String? isValidEmail(String? email) {
  // If required but the input is null or empty, it's invalid.
  if (email == null || email.isEmpty) {
    return 'Please enter your email';
  }

  // Regular expression pattern for validating an email address.
  const pattern =
      r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))'
      r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  // Create a RegExp object with the pattern.
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(email)) {
    return 'Please enter a valid email address';
  }
  return null;
}
