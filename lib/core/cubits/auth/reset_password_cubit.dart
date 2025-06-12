import 'package:baseera_app/core/cubits/auth/reset_password_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/auth_service.dart';

// Reset Password Cubit
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthService _authService;
  String? _resetToken;

  ResetPasswordCubit(this._authService) : super(ResetPasswordInitial());

  Future<void> sendVerificationCode({required String email}) async {
    emit(ResetPasswordLoading());
    try {
      final response = await _authService.sendVerificationCode(email: email);
      final String message = response['message'] ?? 'Verification code sent successfully';
      final String resetToken = response['resetToken'] ?? response['token'] ?? '';

      // Store the reset token from the send-code response
      _resetToken = resetToken;

      emit(CodeSentSuccess(message: message));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  Future<void> verifyCode({
    required String resetToken,
    required String resetCode,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final response = await _authService.verifyResetCode(
        resetToken: resetToken,
        resetCode: resetCode,
      );

      final String message = response['message'] ?? 'Code verified successfully';
      final String newResetToken = response['resetToken'] ?? '';

      // Store the reset token for password reset
      _resetToken = newResetToken;
      emit(CodeVerifiedSuccess(message: message, resetToken: newResetToken));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      final response = await _authService.resetPasswordWithToken(
        resetToken: resetToken,
        newPassword: newPassword,
      );

      final String message = response['message'] ?? 'Password reset successfully';
      emit(PasswordResetSuccess(message: message));
    } catch (e) {
      emit(ResetPasswordError(message: e.toString()));
    }
  }

  String? get resetToken => _resetToken;
}