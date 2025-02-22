import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/buttons.dart';
import '../on_boarding/on_boarding.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 120,),
              /// 📌 **Success Icon**
              Center(
                child: Image.asset(
                  'assets/images/success.png', // Ensure this image exists in assets
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
        
              const SizedBox(height: 30),
        
              /// 📌 **Congrats Text**
              const Text(
                "Congrats! 🎉",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              const SizedBox(height: 8),
        
              /// 📌 **Subtitle**
              const Text(
                "Welcome! Your account has been\ncreated successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
        
              const SizedBox(height: 40),
        
              /// 📌 **Let’s Go! Button using custom Button widget**
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Button(
                  text: "Let’s Go!",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
