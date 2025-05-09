import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../controller/chat_controller.dart';
import '../../../themes/colors.dart';
import '../widgets/type_indicator.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ChatController());
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "MyPerfectLife Ai",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: titleColor2,
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
                child: Obx(() {
                  // Scroll to bottom when messages or typing state changes
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  return ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    children: [
                      // Build all chat messages
                      ..._controller.messages.map((message) => _buildChatBubble(message)),
                      // Typing indicator
                      if (_controller.isTyping.value) _buildTypingIndicator(),
                      // Bottom padding
                      SizedBox(height: _controller.hasConversationEnded.value ? 60.h : 0),
                    ],
                  );
                }),
              ),
              /// Message Input Field
              _buildMessageInput(),
            ],
          ),

          // Add to Goals button
          Obx(() => _controller.hasConversationEnded.value
              ? Positioned(
            left: 20.w,
            bottom: 80.h,
            child: _buildAddToGoalsButton(),
          )
              : SizedBox.shrink()),
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

          // Message content
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
        child: Image.asset(
          isUser ? "assets/images/person.png" : "assets/images/ai_avatar.png",
          width: 32.w,
          height: 32.h,
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Color(0xffD1D5DB),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Write a message...",
                  hintStyle: TextStyle(color: textColor2),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) {
                  _controller.sendMessage(_messageController.text.trim());
                  _messageController.clear();
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                _controller.sendMessage(_messageController.text.trim());
                _messageController.clear();
              },
              child: SvgPicture.asset(
                "assets/svg/chat_button.svg",
                width: 40.w,
                height: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Typing Indicator Widget
  Widget _buildTypingIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // AI Avatar
          _buildAvatar(isUser: false),
          // Typing dots
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 12.h),
            child: TypingIndicator(),
          ),
        ],
      ),
    );
  }
}

