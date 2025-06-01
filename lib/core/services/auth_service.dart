import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.1.3:3000/api/v1';

  Future<Map<String, dynamic>> signUp({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userName': userName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);

        // Extract token from Set-Cookie header
        String? token;
        final setCookieHeader = response.headers['set-cookie'];
        if (setCookieHeader != null) {
          // Parse the token from Set-Cookie header
          final tokenMatch = RegExp(r'token=([^;]+)').firstMatch(setCookieHeader);
          if (tokenMatch != null) {
            token = tokenMatch.group(1);
          }
        }

        return {
          ...responseBody,
          'token': token,
          'headers': response.headers,
        };
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Sign up failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Extract token from Set-Cookie header
        String? token;
        final setCookieHeader = response.headers['set-cookie'];
        if (setCookieHeader != null) {
          // Parse the token from Set-Cookie header
          final tokenMatch = RegExp(r'token=([^;]+)').firstMatch(setCookieHeader);
          if (tokenMatch != null) {
            token = tokenMatch.group(1);
          }
        }

        return {
          ...responseBody,
          'token': token,
          'headers': response.headers,
        };
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Sign in failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Send verification code for password reset
  Future<Map<String, dynamic>> sendVerificationCode({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-code/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to send verification code');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Verify reset code
  Future<Map<String, dynamic>> verifyResetCode({
    required String resetToken,
    required String resetCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'resetToken': resetToken,
          'resetCode': resetCode,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Code verification failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Reset password with token
  Future<Map<String, dynamic>> resetPasswordWithToken({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password/confirm'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'resetToken': resetToken,
          'password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Password reset failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Legacy method - keeping for backward compatibility
  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    return await sendVerificationCode(email: email);
  }
}