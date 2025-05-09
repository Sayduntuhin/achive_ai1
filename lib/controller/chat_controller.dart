import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatController extends GetxController {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Reactive message list
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  // Reactive typing indicator state
  final RxBool isTyping = false.obs;

  // Conversation state
  final RxBool hasConversationEnded = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check for access token and fetch messages
    _checkAuth();
    fetchMessages();
  }

  /// Check if user is authenticated
  Future<void> _checkAuth() async {
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      Get.offNamed('/logIn');
    }
  }

  /// Fetch previous chat messages
  Future<void> fetchMessages() async {
    try {
      final response = await _apiService.getChatMessages();
      if (response['success'] == true) {
        final List<dynamic> chatData = response['data'];
        messages.clear();
        for (var chat in chatData) {
          // Add user message
          messages.add({
            "text": chat['query'] as String,
            "isUser": true,
          });
          // Add AI response
          messages.add({
            "text": chat['answer'] as String,
            "isUser": false,
          });
        }
        if (chatData.isNotEmpty) {
          hasConversationEnded.value = true;
        }
      } else {
        if (response['message'] == 'No access token found. Please log in.') {
          Get.offNamed('/logIn');
        } else {
          Get.snackbar(
            'Error',
            response['message'] ?? 'Failed to fetch messages',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch messages: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Send message and get AI response
  Future<void> sendMessage(String query) async {
    if (query.isNotEmpty) {
      // Add user message
      messages.add({
        "text": query,
        "isUser": true,
      });
      isTyping.value = true;
      hasConversationEnded.value = true;

      try {
        // Send POST request to chat_messages endpoint
        final response = await _apiService.postChatMessage(query: query);

        if (response['success'] == true) {
          // Add AI response
          messages.add({
            "text": response['data']['answer'] as String,
            "isUser": false,
          });
          isTyping.value = false;
        } else {
          // Remove user message on error
          messages.removeLast();
          isTyping.value = false;
          if (response['message'] == 'No access token found. Please log in.') {
            Get.offNamed('/logIn');
          } else {
            Get.snackbar(
              'Error',
              response['message'] ?? 'Failed to send message',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      } catch (e) {
        // Remove user message on error
        messages.removeLast();
        isTyping.value = false;
        Get.snackbar(
          'Error',
          'Failed to send message: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}