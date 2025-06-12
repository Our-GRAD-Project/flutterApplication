// Reset Password States
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class CodeSentSuccess extends ResetPasswordState {
  final String message;
  CodeSentSuccess({required this.message});
}

class CodeVerifiedSuccess extends ResetPasswordState {
  final String message;
  final String resetToken;
  CodeVerifiedSuccess({required this.message, required this.resetToken});
}

class PasswordResetSuccess extends ResetPasswordState {
  final String message;
  PasswordResetSuccess({required this.message});
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  ResetPasswordError({required this.message});
}
