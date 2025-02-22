import 'package:flutter/material.dart';
import '../shared/buttons.dart';
import '../shared/social_buttons.dart';
import '../shared/text_field.dart';
import 'sign_in_screen.dart';
import 'success_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _validateAndSignUp() {
    if (_formKey.currentState!.validate()) {
      // Navigate to Success Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
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
                    'Hello, 👋',
                    style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),

                /// 📌 **Full Name Field**
                CustomTextField(
                  hintText: "Full Name",
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Full name is required";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                /// 📌 **Phone/Email Field**
                CustomTextField(
                  hintText: "Phone/Email",
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

                const SizedBox(height: 16),

                /// 📌 **Password Field**
                CustomTextField(
                  hintText: "Password",
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

                /// 📌 **Sign Up Button**
                Button(
                  text: 'Sign Up',
                  onPressed: _validateAndSignUp,
                ),

                const SizedBox(height: 30),
                /// 📌 **OR Divider**
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400, indent: 90)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or continue with ", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400, endIndent: 90)),
                  ],
                ),
                const SizedBox(height: 20),

                /// 📌 **Social Media Login Buttons**
                const SocialButtons(),

                const SizedBox(height: 30),

                /// 📌 **Already have an account?**
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?", style: TextStyle(color: Colors.grey, fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text('Sign in', style: TextStyle(color: Colors.blue, fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
