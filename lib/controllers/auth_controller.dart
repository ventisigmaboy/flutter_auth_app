// auth_controller.dart
import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService authService = Get.find();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await authService.createAccountWithProfile(
        email: email,
        password: password,
        name: name,
      );

      Get.offAll(() => HomePage());
      print('Create account successful! 👌❤️');
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Registration failed';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Reset errors
      errorMessage.value = '';
      emailError.value = '';
      passwordError.value = '';
      isLoading.value = true;

      // Basic validation
      if (email.isEmpty) {
        emailError.value = 'Email is required';
        return;
      }
      if (!GetUtils.isEmail(email)) {
        emailError.value = 'Enter a valid email';
        return;
      }
      if (password.isEmpty) {
        passwordError.value = 'Password is required';
        return;
      }

      // Firebase authentication
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Success - navigate to home
      Get.offAll(() => HomePage());
      print('Login success! 👌');
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Login failed';
    } finally {
      isLoading.value = false;
    }
  }
}
