import 'dart:async';
import 'package:flutter/material.dart';
import '../shared/buttons.dart';
import 'create_new_password_screen.dart';


class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({Key? key}) : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  late Timer _timer;
  int _secondsRemaining = 60; // 1 minute countdown

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// ⏳ **Starts the countdown timer**
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel(); // Stop timer when it reaches 0
      }
    });
  }

  /// ⏳ **Formats seconds into MM:SS**
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "$minutes:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                  "Verify Code ⚡",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              /// 📌 **Subtitle**
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We just sent a 4-digit verification code. Enter the code in the box below to continue.",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    "Enter the number",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// 📌 **OTP Input Fields**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                      (index) => SizedBox(
                    width: 60,
                    height: 66,
                    child: TextField(
                      controller: _controllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),

              /// 📌 **Resend Code Option with Countdown Timer**
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30),
                  const Text("Didn't receive a code? "),
                  TextButton(
                    onPressed: _secondsRemaining == 0
                        ? () {
                      setState(() {
                        _secondsRemaining = 60; // Reset timer
                        _startTimer();
                      });
                    }
                        : null,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: _secondsRemaining == 0
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                  const Spacer(),

                  /// ⏳ **Dynamic Countdown Timer Display**
                  Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// 📌 **Continue Button**
              Button(
                text: 'Continue',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const CreateNewPasswordScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
