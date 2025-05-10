import 'dart:io';
import 'package:auth_app/controllers/edit_profile_controller.dart';
import 'package:auth_app/widgets/custom_button.dart';
import 'package:auth_app/widgets/custom_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture Section
            Obx(() {
              final currentUser = controller.authService.auth.currentUser;
              return GestureDetector(
                onTap: controller.pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: controller.pickedImage.value != null
                      ? FileImage(File(controller.pickedImage.value!.path))
                      : (currentUser?.photoURL != null
                          ? CachedNetworkImageProvider(currentUser!.photoURL!)
                          : null),
                  child: controller.pickedImage.value == null &&
                          currentUser?.photoURL == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              );
            }),
            const SizedBox(height: 20),
            Text(
              'Tap to change photo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 30),
            
            // Name Field
            CustomFormField(
              controller: controller.nameController,
              isVisible: false,
              hintText: 'Enter your name',
            ),
            const SizedBox(height: 16),
            
            // Email Field
            CustomFormField(
              controller: controller.emailController,
              isVisible: false,
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            
            // Save Button
            Obx(() => CustomButton(
                  buttonColor: Colors.black,
                  textColor: Colors.white,
                  text: 'Save Changes',
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveProfile,
                )),
          ],
        ),
      ),
    );
  }
}