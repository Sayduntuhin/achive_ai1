import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../../../api/api_service.dart';
import '../model/profile_model.dart';
import '../view/widgets/snackbar_helper.dart';
import 'package:logger/logger.dart';

class ProfileController extends GetxController {
  final Logger _logger = Logger();
  // Reactive profile model
  final profile = ProfileModel().obs;
  // Text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();
  final bioController = TextEditingController();
  // Reactive state
  final isNameEditable = false.obs;
  final isPasswordVisible = false.obs;
  final isBioEditable = false.obs;
  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);
  bool _isFetching = false; // Prevent concurrent fetches
  final String instanceId = DateTime.now().millisecondsSinceEpoch.toString(); // Track controller instance

  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _logger.i('ProfileController initialized, instance: $instanceId');
    fetchProfile();
  }

  @override
  void onClose() {
    _logger.i('ProfileController closed, instance: $instanceId');
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthdayController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    if (_isFetching) {
      _logger.w('FetchProfile already in progress, skipping');
      return;
    }

    try {
      _isFetching = true;
      isLoading.value = true;
      _logger.i('Fetching profile from API');
      profile.value = ProfileModel(); // Clear existing profile data
      final response = await _apiService.getProfile();
      _logger.d('Fetch Profile Response: $response');

      if (response['success']) {
        final data = response['data'];
        profile.value = ProfileModel.fromJson(data);
        // Update controllers
        nameController.text = profile.value.fullName ?? '';
        emailController.text = profile.value.email ?? '';
        bioController.text = profile.value.bio ?? '';
        birthdayController.text = profile.value.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(profile.value.dateOfBirth!)
            : '';
        _logger.i('Profile fetched: ${profile.value.fullName}, email: ${profile.value.email}');
      } else {
        SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      _logger.e('Exception in fetchProfile: $e');
      SnackbarHelper.showErrorSnackbar('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  Future<void> updateProfile() async {
    // Validate bio length
    if (bioController.text.length > 200) {
      SnackbarHelper.showErrorSnackbar('Bio must be 200 characters or less');
      return;
    }

    // Validate birthday format
    DateTime? dateOfBirth;
    if (birthdayController.text.isNotEmpty) {
      try {
        dateOfBirth = DateFormat('dd/MM/yyyy').parseStrict(birthdayController.text);
      } catch (e) {
        SnackbarHelper.showErrorSnackbar('Invalid date format');
        return;
      }
    }

    try {
      isLoading.value = true;
      _logger.i('Updating profile');
      final response = await _apiService.updateProfile(
        fullName: nameController.text.isNotEmpty ? nameController.text : null,
        bio: bioController.text.isNotEmpty ? bioController.text : null,
        dateOfBirth: dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(dateOfBirth)
            : null,
        profileImage: selectedImage.value,
      );
      _logger.d('Update Profile Response: $response');

      if (response['success']) {
        final data = response['data'];
        profile.value = ProfileModel.fromJson(data);
        selectedImage.value = null; // Clear local image
        // Update controllers
        nameController.text = profile.value.fullName ?? '';
        emailController.text = profile.value.email ?? '';
        bioController.text = profile.value.bio ?? '';
        birthdayController.text = profile.value.dateOfBirth != null
            ? DateFormat('dd/MM/yyyy').format(profile.value.dateOfBirth!)
            : '';
        _logger.i('Profile updated: ${profile.value.fullName}');
        SnackbarHelper.showSuccessSnackbar('Profile updated successfully');
      } else {
        _logger.e('Error updating profile: ${response['message']}');
        SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _logger.e('Exception in updateProfile: $e');
      SnackbarHelper.showErrorSnackbar('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNameEditable() {
    isNameEditable.value = !isNameEditable.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleBioEditable() {
    isBioEditable.value = !isBioEditable.value;
  }

  void showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
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
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 24.sp, color: Colors.blue),
                title: Text(
                  'Camera',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, size: 24.sp, color: Colors.blue),
                title: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
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

  Future<void> pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        var cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          SnackbarHelper.showErrorSnackbar('Camera permission denied');
          return;
        }
      } else if (source == ImageSource.gallery) {
        var photoStatus = await Permission.photos.request();
        if (!photoStatus.isGranted) {
          SnackbarHelper.showErrorSnackbar('Photos permission denied');
          return;
        }
      }

      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = File(image.path);
        _logger.i('Image picked: ${image.path}');
      }
    } catch (e) {
      _logger.e('Image picker error: $e');
      SnackbarHelper.showErrorSnackbar('Failed to pick image: $e');
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      _logger.i('Date picked: ${birthdayController.text}');
    }
  }
}