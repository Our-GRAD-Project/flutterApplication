import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/cubits/auth/reset_password_cubit.dart';
import '../../core/cubits/auth/reset_password_states.dart';
import '../shared/buttons.dart';
import 'create_new_password_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  const VerifyCodeScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController()); // Changed from 4 to 6
  late Timer _timer;
  int _secondsRemaining = 60; // 1 minute countdown
  String? _resetToken; // Store the reset token from send-code response

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Get the stored reset token from the cubit
    _resetToken = context.read<ResetPasswordCubit>().resetToken;
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

  String _getEnteredCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _verifyCode() {
    final enteredCode = _getEnteredCode();
    if (enteredCode.length == 6) {
      final resetToken = context.read<ResetPasswordCubit>().resetToken;

      if (resetToken == null || resetToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset token not found. Please request a new verification code.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<ResetPasswordCubit>().verifyCode(
        resetToken: resetToken,
        resetCode: enteredCode,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendCode() {
    if (_secondsRemaining == 0) {
      context.read<ResetPasswordCubit>().sendVerificationCode(
        email: widget.email,
      );
      setState(() {
        _secondsRemaining = 60; // Reset timer
        _startTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
              if (state is CodeVerifiedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                // Navigate to Create New Password Screen with reset token
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewPasswordScreen(
                      resetToken: state.resetToken,
                    ),
                  ),
                );
              } else if (state is ResetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is CodeSentSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Code resent successfully')),
                );
              }
            },
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We just sent a 6-digit verification code to ${widget.email}. Enter the code in the box below to continue.", // Changed from 4-digit to 6-digit
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
                    6, // Changed from 4 to 6
                        (index) => SizedBox(
                      width: 50, // Reduced width slightly to fit 6 fields
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
                          if (value.isNotEmpty && index < 5) { // Changed from 3 to 5
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
                      onPressed: _secondsRemaining == 0 ? _resendCode : null,
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

                /// 📌 **Continue Button with Loading State**
                BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                  builder: (context, state) {
                    if (state is ResetPasswordLoading) {
                      return const Button(
                        text: 'Verifying...',
                        onPressed: null,
                      );
                    }
                    return Button(
                      text: 'Continue',
                      onPressed: _verifyCode,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}