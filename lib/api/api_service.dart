import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.10.35:8000/';
  static const int _timeoutSeconds = 30;
  static const int _maxRetries = 2;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Logger _logger = Logger();
  static String get baseUrl => _baseUrl;

  ///----------------------------------------Sign Up----------------------------------------
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final response = await http
            .post(
          Uri.parse('${_baseUrl}accounts/signup/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'name': name,
            'password': password,
          }),
        )
            .timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Signup API response: ${response.statusCode} ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            'success': true,
            'data': data,
          };
        } else {
          String message = 'Signup failed';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['email'] != null) {
            message = data['email'][0] ?? 'Invalid email';
          } else if (data['password'] != null) {
            message = data['password'][0] ?? 'Invalid password';
          } else if (data['message'] != null) {
            message = data['message'];
          }
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Signup timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to sign up. Please try again.',
    };
  }
///----------------------------------------Login----------------------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      _logger.i('Login API response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'tokens': {
            'access': data['access'],
            'refresh': data['refresh'],
          },
        };
      } else {
        final data = jsonDecode(response.body);
        _logger.w('Login failed: ${response.body}');
        return {
          'success': false,
          'message': data['detail'] ?? 'Login failed',
        };
      }
    } catch (e) {
      _logger.e('Error during login API call: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
  ///----------------------------------------Reset Password----------------------------------------
  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final response = await http
            .post(
          Uri.parse('${_baseUrl}accounts/request_password_reset/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
          }),
        )
            .timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Password reset request API response: ${response.statusCode} ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            'success': true,
            'message': data['message'] ?? 'An OTP has been sent to your email',
          };
        } else {
          String message = 'Failed to request password reset';
          if (data['error'] != null) {
            message = data['error']; // e.g., "No account found with this email"
          } else if (data['email'] != null) {
            message = data['email'][0] ?? 'Invalid email';
          } else if (data['message'] != null) {
            message = data['message'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          }
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Password reset request timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to request password reset. Please try again.',
    };
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({required String email, required String otp}) async {
    final url = Uri.parse('$_baseUrl/accounts/verify_otp/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      _logger.i('Verify OTP API response: ${response.statusCode} ${response.body}');
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {'success': true, 'message': data['message'] ?? 'Otp is Correct'};
      } else {
        return {'success': false, 'error': data['error'] ?? 'The OTP is incorrect.'};
      }
    } catch (e) {
      _logger.e('Error in verifyOtp: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final url = Uri.parse('$_baseUrl/accounts/reset_password/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );

      _logger.i('Reset password API response: ${response.statusCode} ${response.body}');

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Password changed successfully'};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Failed to reset password'};
      }
    } catch (e) {
      _logger.e('Error in resetPassword: $e');
      throw Exception('Failed to reset password: $e');
    }
  }

  ///----------------------------------------Post Chat Message----------------------------------------
  Future<Map<String, dynamic>> postChatMessage({
    required String query,
  }) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http
            .post(
          Uri.parse('${_baseUrl}chat_messages/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({
            'query': query,
          }),
        )
            .timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Chat message API response: ${response.statusCode} ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            'success': true,
            'data': data,
          };
        } else {
          String message = 'Failed to send message';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Chat message timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to send message. Please try again.',
    };
  }
  ///----------------------------------------Get Chat Messages----------------------------------------
  Future<Map<String, dynamic>> getChatMessages() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http
            .get(
          Uri.parse('${_baseUrl}chat_messages/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
            .timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get chat messages API response: ${response.statusCode} ${response.body}');

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'data': data,
          };
        } else {
          String message = 'Failed to fetch messages';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get chat messages timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch messages. Please try again.',
    };
  }

}