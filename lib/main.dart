import 'package:auth_app/pages/home_page.dart';
import 'package:auth_app/pages/signup_page.dart';
import 'package:auth_app/services/auth_service.dart';
import 'package:auth_app/services/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(AuthService());
  Get.put(UserRepository());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());
    return GetMaterialApp(
      title: 'Auth App',
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        Get.find<AuthService>();

        if (snapshot.hasData) {
          return HomePage();
        } else {
          return SignupPage();
        }
      },
    );
  }
}
