import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/widgets/custom_elevated_button.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final email = _emailController.text.trim();

      try {
        // Gửi yêu cầu reset password
        await authService.resetPassword(email);

        // Hiển thị dialog thành công
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "SUCCESS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Nội dung thông báo
                  const Text(
                    "Your Account Security is Our Priority! We've Sent You a Secure Link to Safely Change Your Password and Keep Your Account Protected.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Nút Done
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    buttonStyle: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.h),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 32,
                      ),
                    ),
                    text: "Done"
                  ),
                  const SizedBox(height: 16),

                  // Link Resend Email
                  GestureDetector(
                    onTap: () {
                      // Logic xử lý gửi lại email
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar() // Xóa snackbar cũ
                        ..showSnackBar(
                          const SnackBar(content: Text("Email resent!")),
                        );
                    },
                    child: const Text(
                      "Resend Email",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Chuyển về màn hình trước
        Navigator.pop(context);
      } catch (e) {
        // Hiển thị thông báo lỗi nếu thất bại
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "E-mail*",
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: "Please enter your email",
                      textInputType: TextInputType.emailAddress,
                      contentPadding: EdgeInsets.all(10.h),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomElevatedButton(
                      onPressed: _sendResetLink,
                      text: 'Send Reset Link',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 110.0,
          title: Text(
            'Forgot Password',
            style: theme.textTheme.titleMedium!.copyWith(
              color: appTheme.black900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 32.h),
        Image.asset('lib/assets/icons/key.png'),
        SizedBox(height: 16.h),
        Text(
          "Forgot Password ?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8C68EE),
            fontSize: 18.h,
          ),
        ),
        Text(
          "No worries, we'll send a 6-digit code to your email ",
          style: TextStyle(
            fontSize: 14.h,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9DA4AE),
          ),
        ),
        Text(
          "Enter code to reset your password.",
          style: TextStyle(
            fontSize: 14.h,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9DA4AE),
          ),
        ),
      ],
    );
  }
}
