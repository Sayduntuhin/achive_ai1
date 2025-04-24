import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Empty message list initially
  final List<Map<String, dynamic>> _messages = [];

  bool _hasConversationEnded = false;

  /// Scroll to the bottom smoothly
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Send Message & AI Reply
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        // Add user message
        _messages.add({
          "text": _messageController.text,
          "isUser": true
        });

        // Add AI response
        _messages.add({
          "text": "It's a completely normal feeling! But you're not alone. If you had everything organized simply, life would be much better, wouldn't it?",
          "isUser": false,
        });

        _messageController.clear();

        // Mark conversation as having at least one exchange
        _hasConversationEnded = true;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Achieve AI",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: titleColor,
            fontFamily: "Philosopher",
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              /// Chat Messages
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  children: [
                    // Build all chat messages
                    ..._messages.map((message) => _buildChatBubble(message)),

                    // Add some bottom padding to ensure messages don't get hidden behind the input
                    SizedBox(height: _hasConversationEnded ? 60.h : 0),
                  ],
                ),
              ),
              /// Message Input Field
              _buildMessageInput(),
            ],
          ),

          // Add to Goals button - positioned at bottom left
          if (_hasConversationEnded)
            Positioned(
              left: 20.w,
              bottom: 80.h, // Positioned above the message input
              child: _buildAddToGoalsButton(),
            ),
        ],
      ),
    );
  }

  /// Chat Bubble Widget
  Widget _buildChatBubble(Map<String, dynamic> message) {
    bool isUser = message["isUser"] as bool;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI Avatar (only shown for AI messages)
          if (!isUser) _buildAvatar(isUser: false),

          // Message content - simplified with no decorations
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.7.sw),
              child: Text(
                message["text"],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xff555555),
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ),

          // User Avatar (only shown for user messages)
          if (isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  /// Avatar Widget
  Widget _buildAvatar({required bool isUser}) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUser ? Colors.grey[300] : Colors.blue[200],
      ),
      child: Center(
        child: Icon(
          isUser ? Icons.person : Icons.emoji_emotions,
          size: 18.w,
          color: isUser ? Colors.grey[700] : Colors.blue[700],
        ),
      ),
    );
  }

  /// Add To Goals Button
  Widget _buildAddToGoalsButton() {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          "Goal Added",
          "The AI suggestion has been added to your goals!",
          backgroundColor: Colors.deepPurple[400],
          colorText: Colors.white,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.deepPurple[400],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          "Add to Goals",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Message Input Field
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Write a message...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}