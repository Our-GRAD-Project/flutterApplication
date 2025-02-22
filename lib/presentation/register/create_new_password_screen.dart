import 'package:flutter/material.dart';
import '../shared/buttons.dart';
import '../shared/text_field.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({Key? key}) : super(key: key);

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
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password successfully updated!')),
      );

      // Navigate back to Sign In screen
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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

                /// 📌 **Continue Button**
                Button(text: 'Continue', onPressed: _validateAndContinue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
