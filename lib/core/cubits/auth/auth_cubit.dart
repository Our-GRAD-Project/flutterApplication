import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _authService.signUp(
        userName: userName,
        email: email,
        password: password,
      );

      final String message = response['message'] ?? 'Signed up successfully';
      final String? token = response['token'];

      if (token != null && token.isNotEmpty) {
        // Store token locally
        await _storeToken(token);
        emit(AuthSignedUp(message: message));
      } else {
        emit(AuthSignedUp(message: message));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      final String message = response['message'] ?? 'Signed in successfully';
      final String? token = response['token'];

      if (token != null && token.isNotEmpty) {
        // Store token locally
        await _storeToken(token);
        emit(AuthSignedIn(
          token: token,
          message: message,
        ));
      } else {
        emit(AuthError(message: 'Token not received from server'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }


  Future<void> signOut() async {
    try {
      await _removeToken();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _getStoredToken();
      if (token != null && token.isNotEmpty) {
        // Optionally validate token with backend
        emit(AuthSignedIn(token: token, message: 'Already signed in'));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}