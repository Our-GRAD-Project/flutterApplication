import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/auth/reset_password_cubit.dart';
import '../../cubits/auth/reset_password_states.dart';
import '../shared/buttons.dart';
import '../shared/text_field.dart';
import '../register/sign_in_screen.dart'; // Add this import

class CreateNewPasswordScreen extends StatefulWidget {
  final String resetToken;

  const CreateNewPasswordScreen({Key? key, required this.resetToken}) : super(key: key);

  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      print('Attempting to reset password with token: ${widget.resetToken}'); // Debug log
      context.read<ResetPasswordCubit>().resetPassword(
        resetToken: widget.resetToken,
        newPassword: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listener: (context, state) {
              print('Current state: $state'); // Debug log

              if (state is PasswordResetSuccess) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );

                // Navigate to Sign In screen with a delay to show the success message
                Future.delayed(const Duration(seconds: 1), () {
                  // Clear the navigation stack and go to sign in
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                        (route) => false,
                  );
                });
              } else if (state is ResetPasswordError) {
                print('Error occurred: ${state.message}'); // Debug log
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              } else if (state is ResetPasswordLoading) {
                print('Loading state detected'); // Debug log
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// 📌 **Logo**
                  Image.asset('assets/images/app_specific/book-open-svgrepo-com 1.png', height: 80, fit: BoxFit.contain),

                  const SizedBox(height: 30),

                  /// 📌 **Title**
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create New Password ✌️",
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📌 **Subtitle**
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter a strong new password. You'll use this to log in to your account.",
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 📌 **New Password Field**
                  CustomTextField(
                    hintText: "New Password",
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 📌 **Confirm Password Field**
                  CustomTextField(
                    hintText: "Confirm Password",
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm password is required";
                      }
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 📌 **Continue Button with Loading State**
                  BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                    builder: (context, state) {
                      if (state is ResetPasswordLoading) {
                        return const Button(
                          text: 'Resetting...',
                          onPressed: null,
                        );
                      }
                      return Button(
                        text: 'Continue',
                        onPressed: _validateAndContinue,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}