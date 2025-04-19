import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../themes/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController nameController = TextEditingController(text: "Mira");
  final TextEditingController emailController = TextEditingController(text: "abc@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "********");
  final TextEditingController birthdayController = TextEditingController(text: "DD/MM/YY");

  bool _isNameEditable = false;
  bool _isPasswordVisible = false;
  File? _selectedImage; // Store selected image

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  // Show bottom sheet for camera/gallery selection
  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(

          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: secondaryTextColor,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 24.sp, color: buttonColor),
                title: Text(
                  'Camera',
                  style: TextStyle(fontSize: 16.sp, color: secondaryTextColor),
                ),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, size: 24.sp, color: buttonColor),
                title: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16.sp, color: secondaryTextColor),
                ),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        var cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Camera permission denied')),
          );
          return;
        }
      } else if (source == ImageSource.gallery) {
        var storageStatus = await Permission.storage.request();
        var photoStatus = await Permission.photos.request();
        if (!storageStatus.isGranted && !photoStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Storage/Photos permission denied')),
          );
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.1.sh),
        child: CustomAppBar(
          backgroundColor: Colors.white,
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
              SizedBox(height: 20.h),
              // Profile Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 45.w,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : AssetImage("assets/images/person.png") as ImageProvider,
                      ),
                      Positioned(
                        bottom: -10.h,
                        right: -5.w,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined, size: 18.sp, color: primaryColor),
                          onPressed: _showImageSourceBottomSheet,
                          padding: EdgeInsets.all(4.w),
                          constraints: BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 0.02.sw),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mira",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 0.01.sh),
                      Row(
                        children: [
                          Text(
                            "Bio:",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                          ),
                          SizedBox(width: 5.w),
                          Container(
                            width: 0.5.sw,
                            height: 0.03.sh,
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 0.02.sh),

              // Reusable Text Fields
              CustomTextFieldForSetting(
                label: "Name",
                hintText: "Mira",
                controller: nameController,
                suffixIconPath: "assets/svg/edit.svg",
                isEditable: _isNameEditable,
                onSuffixTap: () {
                  setState(() {
                    _isNameEditable = !_isNameEditable;
                  });
                },
              ),
              SizedBox(height: 0.01.sh),

              CustomTextFieldForSetting(
                label: "Email",
                hintText: "abc@gmail.com",
                controller: emailController,
                isEditable: false,
              ),
              SizedBox(height: 0.01.sh),

              CustomTextFieldForSetting(
                label: "Password",
                hintText: "********",
                controller: passwordController,
                isPassword: true,
                isEditable: true,
                suffixIconPath: "assets/svg/edit.svg",
                onSuffixTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              SizedBox(height: 0.01.sh),

              CustomTextFieldForSetting(
                label: "Birthday",
                hintText: "DD/MM/YY",
                controller: birthdayController,
                isReadOnly: true,
                suffixIconPath: "assets/svg/edit.svg",
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