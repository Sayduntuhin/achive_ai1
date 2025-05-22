import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../view/widgets/snackbar_helper.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.10.35:5000';
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /* static const String _baseUrl = 'https://4956-115-127-156-9.ngrok-free.app';*/
  static const int _timeoutSeconds = 30;
  static const int _maxRetries = 2;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final Logger _logger = Logger();
  static String get baseUrl => _baseUrl;
  String? accessToken;

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
          Uri.parse('${_baseUrl}/accounts/request_password_reset/'),
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
          Uri.parse('${_baseUrl}/chat_messages/'),
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
          Uri.parse('${_baseUrl}/chat_messages/'),
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
  ///----------------------------------------Get Any Time Tasks----------------------------------------
  Future<Map<String, dynamic>> getAnyTimeTasks() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getAnyTimeTasks');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/scheduled_tasks/get_anytime_tasks/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Any Time Tasks API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as List<dynamic>;
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch Any Time tasks';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Any Time Tasks failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Any Time Tasks timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getAnyTimeTasks: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getAnyTimeTasks: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch Any Time tasks. Please try again.',
    };
  }
///----------------------------------------Mark Task Complete----------------------------------------
  Future<Map<String, dynamic>> markTaskComplete(String taskId) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for markTaskComplete');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.put(
          Uri.parse('$_baseUrl/scheduled_tasks/mark_schedule_task/$taskId/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Mark Task Complete API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to mark task as complete';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Mark Task Complete failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Mark Task Complete timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in markTaskComplete: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in markTaskComplete: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to mark task as complete. Please try again.',
    };
  }
///----------------------------------------Add Task----------------------------------------
  Future<Map<String, dynamic>> createTask({
    required String title,
    required String description,
    String? scheduleTime,
  }) async {
    final accessToken = await _secureStorage.read(key: 'access_token');
    final payload = {
      'title': title,
      'description': description,
      'schedule_time': scheduleTime,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/scheduled_tasks/task/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    _logger.d('Create Task API response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return {
        'success': true,
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to create task: ${response.statusCode}',
      };
    }
  }
  ///----------------------------------------Get Scheduled Tasks----------------------------------------
  Future<Map<String, dynamic>> getScheduledTasks() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getScheduledTasks');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/scheduled_tasks/task/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Scheduled Tasks API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch scheduled tasks';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Scheduled Tasks failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Scheduled Tasks timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getScheduledTasks: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getScheduledTasks: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch scheduled tasks. Please try again.',
    };
  }
///----------------------------------------Get Goal Subtasks----------------------------------------
  Future<Map<String, dynamic>> getGoalSubtasks() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getGoalSubtasks');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/scheduled_tasks/goal_subtasks/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Goal Subtasks API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch goal subtasks';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Goal Subtasks failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Goal Subtasks timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getGoalSubtasks: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getGoalSubtasks: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch goal subtasks. Please try again.',
    };
  }///----------------------------------------Reschedule Task----------------------------------------
  Future<Map<String, dynamic>> rescheduleTask({
    required String taskId,
    required String scheduleTime,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/scheduled_tasks/reschedule_task/$taskId/');
      final accessToken = await _secureStorage.read(key: 'access_token');
      _logger.d('Rescheduling task $taskId with schedule_time: $scheduleTime');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'schedule_time': scheduleTime,
        }),
      );

      _logger.d('Reschedule Task API response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to reschedule task',
        };
      }
    } catch (e) {
      _logger.e('Error rescheduling task $taskId: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }
///----------------------------------------Delete Task----------------------------------------
  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    try {
      final url = Uri.parse('$baseUrl/scheduled_tasks/delete_schedule_task/$taskId');
      final accessToken = await _secureStorage.read(key: 'access_token');
      _logger.d('Deleting task $taskId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      _logger.d('Delete Task API response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 204) {
        _logger.i('Task $taskId deleted successfully');
        return {'success': true};
      } else {
        final errorData = jsonDecode(response.body);
        _logger.e('Failed to delete task $taskId: ${errorData['message']}');
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to delete task',
        };
      }
    } catch (e) {
      _logger.e('Error deleting task $taskId: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }
///----------------------------------------Get Missed Tasks----------------------------------------
  Future<Map<String, dynamic>> getMissedTasks() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getMissedTasks');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/scheduled_tasks/get_missed_tasks/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Missed Tasks API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch missed tasks';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Missed Tasks failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Missed Tasks timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getMissedTasks: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getMissedTasks: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch missed tasks. Please try again.',
    };
  }
  Future<Map<String, dynamic>> getGoals() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getGoals');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http
            .get(
          Uri.parse('$_baseUrl/goal/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
            .timeout(const Duration(seconds: _timeoutSeconds));

        _logger.i('Get Goals API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final List<dynamic> goals = jsonDecode(response.body);
          return {
            'success': true,
            'goals': goals,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch goals';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Goals failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Goals timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getGoals: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getGoals: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch goals. Please try again.',
    };
  }

  ///----------------------------------------Get Subtask----------------------------------------
  Future<Map<String, dynamic>> getSubtask(String subtaskId) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getSubtask');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http
            .get(
          Uri.parse('$_baseUrl/goal/subtasks/$subtaskId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        )
            .timeout(const Duration(seconds: _timeoutSeconds));

        _logger.i('Get Subtask API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'subtask': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch subtask';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Subtask failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Subtask timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getSubtask: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getSubtask: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch subtask. Please try again.',
    };
  }
  ///----------------------------------------Update Subtask----------------------------------------
  Future<Map<String, dynamic>> updateSubtask(String id, Map<String, dynamic> data) async {
    try {
      final accessToken = await _secureStorage.read(key: 'access_token');
      if (accessToken == null) {
        _logger.w('No access token found for getSubtask');
        return {
          'success': false,
          'message': 'No access token found. Please log in.',
        };
      }
      final response = await http.patch(
        Uri.parse('$baseUrl/goal/subtasks/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'

        },
        body: jsonEncode(data),
      );
      _logger.d('Update Subtask $id API response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        return {'success': true, 'subtask': jsonDecode(response.body)};
      }
      final error = jsonDecode(response.body);
      return {'success': false, 'message': error['error'] ?? 'Failed to update subtask: ${response.statusCode}'};
    } catch (e) {
      _logger.e('Error updating subtask $id: $e');
      return {'success': false, 'message': 'Error updating subtask: $e'};
    }
  }
  Future<Map<String, dynamic>> getProfile() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getProfile');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/accounts/profile/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Profile API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch profile';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Profile failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Profile timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getProfile: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getProfile: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch profile. Please try again.',
    };
  }

  // PATCH /accounts/profile/
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? bio,
    String? dateOfBirth,
    File? profileImage,
  }) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for updateProfile');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse('$_baseUrl/accounts/profile/'),
        );

        // Add headers
        request.headers['Authorization'] = 'Bearer $accessToken';

        // Add text fields if provided
        if (fullName != null) request.fields['full_name'] = fullName;
        if (bio != null) request.fields['bio'] = bio;
        if (dateOfBirth != null) request.fields['date_of_birth'] = dateOfBirth;

        // Add profile image if provided
        if (profileImage != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'profile_image',
              profileImage.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }

        final response = await request.send().timeout(Duration(seconds: _timeoutSeconds));
        final responseBody = await response.stream.bytesToString();

        _logger.i('Update Profile API response: ${response.statusCode} $responseBody');

        if (response.statusCode == 200) {
          final data = jsonDecode(responseBody);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(responseBody);
          String message = 'Failed to update profile';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Update Profile failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Update Profile timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in updateProfile: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in updateProfile: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to update profile. Please try again.',
    };
  }
  ///----------------------------------------Submit Device Token----------------------------------------
  Future<Map<String, dynamic>> submitDeviceToken(String deviceToken) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for submitDeviceToken');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.post(
          Uri.parse('$_baseUrl/accounts/submit_device_token/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode({'device_token': deviceToken}),
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Submit Device Token API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return {'success': true};
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to submit device token';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Submit Device Token failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Submit Device Token timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in submitDeviceToken: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in submitDeviceToken: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to submit device token. Please try again.',
    };
  }
  ///----------------------------------------Get Notifications----------------------------------------
  Future<Map<String, dynamic>> getNotifications() async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for getNotifications');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.get(
          Uri.parse('$_baseUrl/notification/list/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Get Notifications API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return {
            'success': true,
            'data': data,
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to fetch notifications';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Get Notifications failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Get Notifications timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in getNotifications: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in getNotifications: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to fetch notifications. Please try again.',
    };
  }
  ///----------------------------------------Mark Notification as Read----------------------------------------
  Future<Map<String, dynamic>> markNotificationAsRead(String notificationId) async {
    int attempt = 0;
    while (attempt < _maxRetries) {
      try {
        final accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken == null) {
          _logger.w('No access token found for markNotificationAsRead');
          return {
            'success': false,
            'message': 'No access token found. Please log in.',
          };
        }

        final response = await http.patch(
          Uri.parse('$_baseUrl/notification/$notificationId/mark_as_read/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ).timeout(Duration(seconds: _timeoutSeconds));

        _logger.i('Mark Notification as Read API response: ${response.statusCode} ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 204) {
          return {
            'success': true,
            'message': 'Notification marked as read',
          };
        } else {
          final data = jsonDecode(response.body);
          String message = 'Failed to mark notification as read';
          if (data['error'] != null) {
            message = data['error'];
          } else if (data['detail'] != null) {
            message = data['detail'];
          } else if (data['message'] != null) {
            message = data['message'];
          }
          _logger.w('Mark Notification as Read failed: $message');
          return {
            'success': false,
            'message': message,
          };
        }
      } on TimeoutException {
        attempt++;
        _logger.w('Mark Notification as Read timeout, attempt $attempt of $_maxRetries');
        if (attempt >= _maxRetries) {
          return {
            'success': false,
            'message': 'Request timed out. Please try again.',
          };
        }
      } on http.ClientException catch (e) {
        _logger.e('Network error in markNotificationAsRead: $e');
        return {
          'success': false,
          'message': 'Network error. Please check your connection.',
        };
      } catch (e) {
        _logger.e('Unexpected error in markNotificationAsRead: $e');
        return {
          'success': false,
          'message': 'An unexpected error occurred. Please try again.',
        };
      }
    }
    return {
      'success': false,
      'message': 'Failed to mark notification as read. Please try again.',
    };
  }
}

