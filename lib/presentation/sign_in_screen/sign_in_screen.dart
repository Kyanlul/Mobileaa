import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_button_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers for input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final bool _loading = false;
  final String _error = '';

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.lightGray,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [

            _buildForm(),
            _buildForgotPasswordButton(context),
            _buildSignInButtons(authService),
            const SizedBox(height: 12),
            _buildRegisterRow(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: CustomBottomBar(
          selectedIndex: 2,
          onChanged: (BottomBarEnum type) {

          },
        )
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 110.0,
          title: Text(
            'Login',
            style: theme.textTheme.titleMedium!.copyWith(
              color: appTheme.black900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100),
          _buildWelcomeMessage(),
          const SizedBox(height: 50),
          _buildEmailField(),
          const SizedBox(height: 10),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "Welcome to SnapShop".toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 32, // Điều chỉnh kích thước font chữ theo nhu cầu
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2, // Điều chỉnh chiều cao giữa các dòng
            ),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   'Login to your account',
          //   style: CustomTextStyles.bodyMediumOnPrimaryContainer_1,
          // ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20, // Điều chỉnh kích thước font chữ theo nhu cầu
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        CustomTextFormField(
          controller: _emailController,
          hintText: "Please enter your email",
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.all(10.h),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter your email';
            }
            if (!value!.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20, // Điều chỉnh kích thước font chữ theo nhu cầu
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        CustomTextFormField(
          controller: _passwordController,
          hintText: "Please enter your password",
          textInputType: TextInputType.text,
          obscureText: !_isPasswordVisible,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          ),
          contentPadding: EdgeInsets.all(10.h),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.forgotPasswordScreen);
        },
        child: Text(
          'Forgot password',
          style: CustomTextStyles.bodyMediumPrimary,
        ),
      ),
    );
  }

  Widget _buildSignInButtons(AuthService authService) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: 'Sign In',
            height: 50,
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _signIn(authService),
          ),
        ),
        // const SizedBox(width: 10),
        // Container(
        //   width: 50,
        //   height: 50,
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFFA993A),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   // child: IconButton(
        //   //   icon: const Icon(Icons.fingerprint, color: Colors.white),
        //   //   onPressed: () {
        //   //     debugPrint("Fingerprint login");
        //   //   },
        //   // ),
        // ),
      ],
    );
  }

  Widget _buildRegisterRow(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don’t have an account?',
            style: TextStyle(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.signUpScreen);
            },
            child: const Text(
              'Register',
              style: TextStyle(color: Color(0xFF42A5F5)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn(AuthService authService) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final UserCredential userCredential = await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null && mounted) {
        Navigator.pushNamed(context, AppRoutes.homeScreen);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
