import 'package:achive_ai/api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';

class AuthService {
  static String baseUrl = ApiService.baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Logger _logger = Logger();

  // Store tokens
  Future<void> storeTokens({required String access, required String refresh}) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
    _logger.d('Tokens stored: access=$access, refresh=$refresh');
  }

  // Retrieve access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Check if token is valid (not expired)
  bool _isTokenValid(String token) {
    try {
      // Split JWT and decode payload
      final parts = token.split('.');
      if (parts.length != 3) {
        _logger.w('Invalid JWT format');
        return false;
      }
      // Decode base64 payload (part 1)
      final payload = parts[1];
      // Handle base64 padding
      final normalizedPayload = payload.padRight((payload.length + 3) ~/ 4 * 4, '=');
      final decodedPayload = base64Url.decode(normalizedPayload);
      final payloadMap = jsonDecode(utf8.decode(decodedPayload)) as Map<String, dynamic>;

      // Check expiration
      final exp = payloadMap['exp'] as int?;
      if (exp == null) {
        _logger.w('Token has no expiration claim');
        return false;
      }
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      return now.isBefore(expirationDate);
    } catch (e) {
      _logger.e('Error decoding token: $e');
      return false;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      _logger.d('No access token found');
      return false;
    }

    if (_isTokenValid(accessToken)) {
      _logger.d('Access token is valid');
      return true;
    }

    // Access token expired, try refreshing
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || !_isTokenValid(refreshToken)) {
      _logger.w('Refresh token is missing or expired');
      await logout();
      return false;
    }

    // Refresh token
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );
      _logger.i('Token refresh API response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storeTokens(access: data['access'], refresh: refreshToken);
        _logger.d('Token refreshed successfully');
        return true;
      } else {
        _logger.w('Token refresh failed: ${response.body}');
        await logout();
        return false;
      }
    } catch (e) {
      _logger.e('Error refreshing token: $e');
      await logout();
      return false;
    }
  }

  Future<Map<String, dynamic>> socialSignIn({
    required String name,
    required String email,
    required String timeZone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/social_signup_signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name' : name,
          'email': email,
          'time_zone_info': timeZone,
        }),
      );

      _logger.i('Social sign-in API response: ${response.statusCode} ${response.body}');

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
        _logger.w('Social sign-in failed: ${response.body}');
        return {
          'success': false,
          'message': data['detail'] ?? 'Social sign-in failed',
        };
      }
    } catch (e) {
      _logger.e('Error during social sign-in API call: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred during social sign-in',
      };
    }
  }

  // Logout
  Future<bool> logout() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      _logger.w('No refresh token found for logout');
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      _logger.i('Tokens cleared');
      return true;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/logout/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );
      _logger.i('Logout API response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        _logger.i('Logout successful, tokens cleared');
        return true;
      } else {
        _logger.w('Logout API failed: ${response.body}');
        await _storage.delete(key: 'access_token');
        await _storage.delete(key: 'refresh_token');
        _logger.i('Tokens cleared despite API failure');
        return false;
      }
    } catch (e) {
      _logger.e('Error during logout: $e');
      await _storage.delete(key: 'access_token');
      await _storage.delete(key: 'refresh_token');
      _logger.i('Tokens cleared after error');
      return false;
    }
  }
}