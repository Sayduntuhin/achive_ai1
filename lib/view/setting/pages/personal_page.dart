import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/profile_controller.dart';
import '../../../themes/colors.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class PersonalInformationScreen extends StatelessWidget {
  const PersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a tagged controller to ensure a single instance
    final ProfileController controller = Get.put(ProfileController(), tag: 'personalInfo');
    // Trigger fetchProfile on navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();
    });

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
      body: Obx(
            () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                // Profile Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with camera icon
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 45.w,
                          backgroundImage: controller.selectedImage.value != null
                              ? FileImage(controller.selectedImage.value!)
                              : controller.profile.value.profileImage != null
                              ? NetworkImage(controller.profile.value.profileImage!)
                              : const AssetImage("assets/images/empty_person.png") as ImageProvider,
                        ),
                        Positioned(
                          bottom: -10.h,
                          right: -5.w,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              size: 18.sp,
                              color: primaryColor,
                            ),
                            onPressed: () => controller.showImageSourceBottomSheet(context),
                            padding: EdgeInsets.all(4.w),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15.w),
                    // User info with constrained width
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.profile.value.fullName?.isEmpty ?? true
                                ? "User"
                                : controller.profile.value.fullName!,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8.h),
                          CustomTextFieldForSetting(
                            label: "Bio",
                            hintText: "Tell us about yourself",
                            controller: controller.bioController,
                            isEditable: controller.isBioEditable.value,
                            suffixIconPath: "assets/svg/edit.svg",
                            onSuffixTap: controller.toggleBioEditable,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Text Fields
                CustomTextFieldForSetting(
                  label: "Name",
                  hintText: "Enter your name",
                  controller: controller.nameController,
                  suffixIconPath: "assets/svg/edit.svg",
                  isEditable: controller.isNameEditable.value,
                  onSuffixTap: controller.toggleNameEditable,
                ),
                SizedBox(height: 10.h),
                CustomTextFieldForSetting(
                  label: "Email",
                  hintText: "Enter your email",
                  controller: controller.emailController,
                  isEditable: false,
                ),
                SizedBox(height: 10.h),
                CustomTextFieldForSetting(
                  label: "Password",
                  hintText: "********",
                  controller: controller.passwordController,
                  isPassword: true,
                  isEditable: true,
                  suffixIconPath: "assets/svg/edit.svg",
                  onSuffixTap: controller.togglePasswordVisibility,
                ),
                SizedBox(height: 10.h),
                CustomTextFieldForSetting(
                  label: "Birthday",
                  hintText: "DD/MM/YY",
                  controller: controller.birthdayController,
                  isReadOnly: true,
                  suffixIconPath: "assets/svg/edit.svg",
                  onSuffixTap: () => controller.pickDate(context),
                ),
                SizedBox(height: 20.h),
                // Save Button
                SizedBox(
                  width: 0.5.sw,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}