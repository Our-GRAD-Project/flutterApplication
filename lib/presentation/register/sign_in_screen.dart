import 'package:flutter/material.dart';
import '../shared/buttons.dart';
import '../shared/social_buttons.dart';
import '../shared/text_field.dart';
import '../on_boarding/on_boarding.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _validateAndSignIn() {
    if (_formKey.currentState!.validate()) {
      // Navigate to Onboarding Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please enter your email and password to sign in',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 40),

                /// 📌 **Email Field**
                CustomTextField(
                  hintText: "Email",
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
                  obscureText: _obscureText,
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
                    icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),

                /// 📌 **Forgot Password**
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password?', style: TextStyle(color: Colors.black)),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📌 **Sign In Button**
                Button(
                  text: 'Sign in',
                  onPressed: _validateAndSignIn,
                ),

                const SizedBox(height: 30),

                /// 📌 **OR Divider**
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400, indent: 90)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Or continue with", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400, endIndent: 90)),
                  ],
                ),

                const SizedBox(height: 20),

                /// 📌 **Social Media Login Buttons**
                const SocialButtons(),

                const SizedBox(height: 30),

                /// 📌 **Sign Up Navigation**
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.grey, fontSize: 18)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: const Text('Sign up', style: TextStyle(color: Colors.blue, fontSize: 18)),
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
