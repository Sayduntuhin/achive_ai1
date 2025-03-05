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
  final ScrollController _scrollController = ScrollController(); // ✅ Scroll Controller

  // Dummy chat messages
  final List<Map<String, dynamic>> _messages = [
   // {"text": "Come on, the first step is to start walking for 10 minutes every day! I’m setting a reminder for you!", "isUser": false, "showButton": true},
  ];

  /// ✅ Scroll to the bottom smoothly
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

  /// ✅ Send Message & AI Reply
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({"text": _messageController.text, "isUser": true});
        _messages.add({"text": "This is an AI-generated response.", "isUser": false});
        _messageController.clear();
      });

      _scrollToBottom(); // ✅ Auto-scroll after sending message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Achieve Ai",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
              fontFamily: "Philosopher",
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          /// ✅ Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // ✅ Attach Scroll Controller
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),

          /// ✅ Message Input Field
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// ✅ Chat Bubble Widget
  Widget _buildChatBubble(Map<String, dynamic> message) {
    bool isUser = message["isUser"] as bool;
    bool showButton = message.containsKey("showButton") ? message["showButton"] : false;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        padding: EdgeInsets.all(12.w),
        constraints: BoxConstraints(maxWidth: 0.75.sw), // Max width of message
        decoration: BoxDecoration(
          color: isUser ? const Color(0xffED840F) : const Color(0xff1C4A5A),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r),
              topLeft: Radius.circular(10.r),
              bottomRight: isUser ? Radius.circular(0) : Radius.circular(10.r), // ✅ If AI, round bottomRight
              bottomLeft: isUser ? Radius.circular(10.r) : Radius.circular(0), // ✅ If User, round bottomLeft
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message["text"],
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontFamily: "Poppins",
              ),
            ),
            if (showButton) ...[
              SizedBox(height: 10.h),
              _buildAddToTaskButton(),
            ]
          ],
        ),
      ),
    );
  }

  /// ✅ "Add To Task" Button
  Widget _buildAddToTaskButton() {
    return GestureDetector(
      onTap: () {
        Get.snackbar("Task Added", "The AI suggestion has been added to your task list!",
            backgroundColor: Colors.green, colorText: Colors.white);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          "Add To Task",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// ✅ Message Input Field
  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: const Color(0xffF5F7FA), // ✅ Light background color
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Write a message...",
                  hintStyle: TextStyle(color: textColor2 ),
                  border: InputBorder.none, // ✅ Removes the default border
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xff1C4A5A), // ✅ Dark background for send button
                  shape: BoxShape.circle, // ✅ Ensures it's a perfect circle
                ),
                child: SvgPicture.asset(
                  "assets/svg/chat_button.svg", // ✅ Your provided send icon
                  width: 20.w,
                  height: 20.h,
                 // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
