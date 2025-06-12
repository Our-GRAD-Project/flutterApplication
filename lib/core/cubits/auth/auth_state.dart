import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {
  final String token;
  final String message;

  const AuthSignedIn({required this.token, required this.message});

  @override
  List<Object?> get props => [token, message];
}

class AuthSignedUp extends AuthState {
  final String message;

  const AuthSignedUp({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthPasswordResetSent extends AuthState {
  final String message;

  const AuthPasswordResetSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignedOut extends AuthState {}