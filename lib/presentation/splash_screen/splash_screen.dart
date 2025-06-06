import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Check login status when the app is initialized
    _checkLoginStatus();
  }

  // Check if the user is logged in and navigate accordingly
  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final isLoggedIn = authService.isLoggedIn();

    // Add a delay of 3 seconds before navigating to the appropriate screen
    Future.delayed(const Duration(seconds: 3), () async {
      // Navigate to HomeScreen if the user is logged in, or WelcomeScreen if not
      if (isLoggedIn) {
        // Navigator.pushNamed(context, AppRoutes.homeScreen);
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      } else {
        Navigator.pushNamed(context, AppRoutes.welcomeOnboardingScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.deepPurpleA200,
      body: Center(
        child: SizedBox(
          height: 200.h,
          width: 200.h,
          child: const CustomImageView(
            imagePath: 'lib/assets/images/logo.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
