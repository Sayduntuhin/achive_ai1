import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen>  createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController nameController = TextEditingController(text: "Mira");
  final TextEditingController emailController = TextEditingController(text: "abc@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "********");
  final TextEditingController birthdayController = TextEditingController(text: "DD/MM/YY");

  bool _isNameEditable = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          title: "Personal Information",
          borderColor: secondaryBorderColor,
          textColor: textColor,
          onBackPress: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45.w,
                    backgroundImage: AssetImage("assets/images/person.png"),
                  ),
                  Column(
                    children: [
                      Text(
                        "Mira",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10.h),
                      Row(
                        children: [
                          Text(
                            "Bio:",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                          ),
                          SizedBox(width: 5.w),
                          Container(
                            width: 100.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange.shade300),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Reusable Text Fields
              CustomTextFieldForSetting(
                label: "Name",
                hintText: "Mira",
                controller: nameController,
                suffixIconPath: "assets/svg/edit.svg",  // Use SVG for suffix icon
                isEditable: _isNameEditable,
                onSuffixTap: () {
                  setState(() {
                    _isNameEditable = !_isNameEditable;
                  });
                },
              ),
              SizedBox(height: 10.h),

              CustomTextFieldForSetting(
                label: "Email",
                hintText: "abc@gmail.com",
                controller: emailController,
                isEditable: false, // Always non-editable
              ),
              SizedBox(height: 10.h),

              CustomTextFieldForSetting(
                label: "Password",
                hintText: "********",
                controller: passwordController,
                isPassword: true,
                isEditable: true,
                suffixIconPath: "assets/svg/edit.svg",  // Toggle SVG
                onSuffixTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 10.h),

              CustomTextFieldForSetting(
                label: "Birthday",
                hintText: "DD/MM/YY",
                controller: birthdayController,
                isReadOnly: true,
                suffixIconPath: "assets/svg/edit.svg",  // Use SVG for calendar
                onSuffixTap: () {
                  // Implement Date Picker functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
