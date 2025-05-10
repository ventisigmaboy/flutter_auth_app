import 'dart:io';
import 'package:auth_app/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;  // Fixed import with alias

class EditProfileController extends GetxController {
  final AuthService _authService = Get.find(); // Private variable with underscore
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString imagePath = ''.obs;
  final Rx<XFile?> pickedImage = Rx<XFile?>(null);
  AuthService get authService => _authService;

  @override
  void onInit() {
    final user = _authService.auth.currentUser; // Use _authService here
    nameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
    super.onInit();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        pickedImage.value = image;
        imagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  Future<String?> _uploadImage() async {
    if (pickedImage.value == null) return null;
    
    try {
      final String fileName = path.basename(pickedImage.value!.path); // Use path.basename
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(fileName);
      
      await storageRef.putFile(File(pickedImage.value!.path));
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
      return null;
    }
  }

  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final String? imageUrl = await _uploadImage();
      
      await _authService.updateProfile( // Use _authService here
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        photoUrl: imageUrl ?? _authService.auth.currentUser?.photoURL, // Fallback to current photo
      );
      
      Get.back();
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}