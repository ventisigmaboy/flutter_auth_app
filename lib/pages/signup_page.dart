import 'package:animate_do/animate_do.dart';
import 'package:auth_app/controllers/auth_controller.dart';
import 'package:auth_app/pages/login_page.dart';
import 'package:auth_app/services/auth_service.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/custom_button.dart';
import 'package:auth_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final AuthService authService = Get.find<AuthService>();
  final AuthController authController = AuthController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String emailError = '';
  bool showEmailError = false;
  bool showPasswordError = false;

  bool isVisible = true;
  bool isPasswordEighChar = false;
  bool hasPasswordOneNum = false;
  bool isLoading = false;

  void onPasswordChange(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      isPasswordEighChar = false;
      if (password.length >= 6) {
        isPasswordEighChar = true;
      }
      hasPasswordOneNum = false;
      if (numericRegex.hasMatch(password)) {
        hasPasswordOneNum = true;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  // Future<void> registerAcc() async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = '';
  //   });

  //   try {
  //     // 1. Create account
  //     await authService.createAcc(
  //       email: emailController.text.trim(),
  //       password: passwordController.text.trim(),
  //     );

  //     // 2. Update display name
  //     await FirebaseAuth.instance.currentUser?.updateProfile(
  //       displayName: nameController.text.trim(),
  //     );

  //     // 3. Navigate after successful signup
  //     Get.offAllNamed('/home'); // Adjust to your route
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       errorMessage = e.message ?? 'Registration failed. Please try again.';
  //     });
  //   } finally {
  //     if (mounted) {
  //       setState(() => isLoading = false);
  //     }
  //   }
  // }

  // Future<void> registerAcc() async {
  //   setState(() => isLoading = true);

  //   try {
  //     // 1. Create auth account
  //     final userCredential = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //           email: emailController.text.trim(),
  //           password: passwordController.text.trim(),
  //         );

  //     // 2. Update display name
  //     await userCredential.user?.updateDisplayName(nameController.text.trim());

  //     // 3. Create Firestore document
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid) // Use UID as document ID
  //         .set({
  //           'uid': userCredential.user!.uid,
  //           'email': emailController.text.trim(),
  //           'name': nameController.text.trim(),
  //           'createdAt': FieldValue.serverTimestamp(),
  //           'isVerified': false,
  //           // Add other custom fields
  //         });

  //     Get.offAllNamed('/home');
  //   } on FirebaseAuthException catch (e) {
  //     setState(() => errorMessage = e.message ?? 'Error during registration');
  //   } finally {
  //     if (mounted) setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(kdefualtPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Text(
                  'Create Account',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 800),
                child: Text(
                  'Please register an account including the following criteria below.',
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: Duration(milliseconds: 900),
                child: CustomFormField(
                  isVisible: false,
                  hintText: 'Enter your name',
                  controller: nameController,
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: CustomFormField(
                  hintText: 'Enter your email',
                  isVisible: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        emailError = 'Email is required';
                        showEmailError = true;
                      });
                      return '';
                    }
                    if (!value.contains('@')) {
                      setState(() {
                        emailError = 'Enter a valid email';
                        showEmailError = true;
                      });
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 1100),
                child: CustomFormField(
                  hintText: 'Enter your password',
                  isVisible: isVisible,
                  controller: passwordController,
                  onChanged: (password) {
                    onPasswordChange(password);
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    icon:
                        isVisible
                            ? Icon(
                              Icons.visibility_outlined,
                              color: Colors.grey,
                            )
                            : Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.grey,
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Obx(
                () =>
                    authController.errorMessage.value.isEmpty
                        ? SizedBox.shrink()
                        : Text(
                          authController.errorMessage.value,
                          style: TextStyle(color: Colors.red),
                        ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 1200),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                isPasswordEighChar
                                    ? Colors.green
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color:
                                isPasswordEighChar
                                    ? Colors.white
                                    : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Contains at least 6 characters',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                hasPasswordOneNum
                                    ? Colors.green
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 15,
                            color:
                                hasPasswordOneNum
                                    ? Colors.white
                                    : Colors.transparent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Contains at least 1 number',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Center(
                  child: CustomButton(
                    text: 'Create Account',
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              authController.register(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                name: nameController.text.trim(),
                              );
                            },
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                  ),
                ),
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Center(
                  child: CustomButton(
                    text: 'Sign in',
                    onPressed: isLoading ? null : () => Get.to(LoginPage()),
                    textColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
