import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/model/user.dart';
import 'package:untitled/services/Database/user_service.dart';
import 'package:untitled/widgets/custom_drop_down.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/sign_up_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final String _selectedNationality = 'Vietnam';
  final String _selectedGender = 'Male';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;
  bool _acceptedMarketing = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms || !_acceptedMarketing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Terms & Conditions')),
      );
      return;
    }

    final authProvider = Provider.of<AuthService>(context, listen: false);

    try {
      final UserCredential userCredential = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final userModel = CustomUser(
        uid: userCredential.user!.uid,
        name: _nameController.text,
        email: _emailController.text,
        pass: _passwordController.text,
        nationality: _selectedNationality,
        gender: _selectedGender,
        phone: _phoneController.text,
      );

      if (userCredential.user != null) {
        print("Signup successful!");
        ProfileService().createUserProfile(userModel);
        Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
      } else {
        throw Exception("Signup failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
            title: Column(
              children: [
                Text(
                  'Sign Up',
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: appTheme.black900,
                  ),
                ),
                SizedBox(height: 10.h),
                Text('Join us for a better shopping experience!',
                    style: theme.textTheme.bodyMedium)
              ],
            ),
          ),
        ),
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Consumer<AuthService>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PERSONAL INFORMATION',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        const Text(
                          '*Please use English character only',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 18.h),

                        // Nationality and Gender dropdowns
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nationality*",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.h),
                                  child: CustomDropDown(
                                    icon: Container(
                                      margin: const EdgeInsets.only(left: 16.0),
                                      child: const Icon(Icons.keyboard_arrow_down),
                                    ),
                                    iconSize: 14.h,
                                    hintText: "Vietnam",
                                    items: SignUpModel().nationalityList,
                                  ),
                                )
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gender*",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.h),
                                  child: CustomDropDown(
                                    icon: Container(
                                      margin: const EdgeInsets.only(left: 16.0),
                                      child: const Icon(Icons.keyboard_arrow_down),
                                    ),
                                    iconSize: 14.h,
                                    hintText: "Male",
                                    items: SignUpModel().genderList,
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                        SizedBox(height: 14.h),

                        //Address and Role

                        SizedBox(
                          height: 14.h,
                        ),

                        // First and Last Name
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name*",
                                  style: theme.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 2.h),
                                Padding(
                                    padding: EdgeInsets.only(right: 8.h),
                                    child: CustomTextFormField(
                                      hintText: "John",
                                      contentPadding: EdgeInsets.all(10.h),
                                      controller: _nameController,
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ))
                              ],
                            )),
                            // SizedBox(width: 14.h),
                            // Expanded(
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Last name*",
                            //           style: theme.textTheme.bodyMedium,
                            //         ),
                            //         SizedBox(height: 2.h),
                            //         Padding(
                            //             padding: EdgeInsets.only(right: 8.h),
                            //             child: CustomTextFormField(
                            //               hintText: "Doe",
                            //               contentPadding: EdgeInsets.all(10.h),
                            //               controller: _nameController,
                            //               validator: (value) {
                            //                 if (value?.isEmpty ?? true) {
                            //                   return 'Please enter your first name';
                            //                 }
                            //                 return null;
                            //               },
                            //             )
                            //         )
                            //       ],
                            //     )
                            // ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'E-mail*',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 2.h),
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
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone*',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                controller: _phoneController,
                                hintText: "Please enter your phone",
                                textInputType: TextInputType.phone,
                                contentPadding: EdgeInsets.all(10.h),
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter your phone';
                                  }

                                  return null;
                                },
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 14.h),

                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password*',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                controller: _passwordController,
                                hintText: "Please enter your password",
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                suffixConstraints:
                                    BoxConstraints(maxHeight: 40.h),
                                contentPadding: EdgeInsets.all(10.h),
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter a password';
                                  }
                                  if (value!.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),

                        SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password*',
                                style: theme.textTheme.bodyMedium,
                              ),
                              SizedBox(height: 2.h),
                              CustomTextFormField(
                                controller: _confirmPasswordController,
                                hintText: "Please re-enter your password",
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                suffixConstraints:
                                    BoxConstraints(maxHeight: 40.h),
                                contentPadding: EdgeInsets.all(10.h),
                                obscureText: _obscureConfirmPassword,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // Checkboxes
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'I hereby read and accepted the Terms & Conditions of GlobalCard App',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _acceptedTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'I agree to receive information about promotions and marketing e-mails from GlobalCart and partners',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: _acceptedMarketing,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptedMarketing = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          child: CustomElevatedButton(
                            onPressed: _submit,
                            text: 'Submit',
                            height: 50.h,
                            buttonStyle: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
