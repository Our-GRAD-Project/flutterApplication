import 'package:flutter/material.dart';
import 'verify_code_screen.dart';
import '../shared/buttons.dart';
import '../shared/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      // Navigate to Verify Code Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyCodeScreen()),
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/app_specific/book-open-svgrepo-com 1.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot password ⚡",
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please enter your email address. We will send an OTP code for verification in the next step.",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 30),

                /// 📌 **Email Input Field with Validation**
                CustomTextField(
                  hintText: "Your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// 📌 **Continue Button**
                Button(
                  text: 'Continue',
                  onPressed: _validateAndContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
