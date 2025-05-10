import 'package:animate_do/animate_do.dart';
import 'package:auth_app/components/custom_drawer.dart';
import 'package:auth_app/models/user_model.dart';
import 'package:auth_app/pages/edit_profile_page.dart';
import 'package:auth_app/pages/login_page.dart';
import 'package:auth_app/services/auth_service.dart';
import 'package:auth_app/services/user_repo.dart';
import 'package:auth_app/widgets/custom_text_form_field.dart';
import 'package:auth_app/widgets/drawer_tile.dart';
import 'package:auth_app/widgets/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService authService = Get.find<AuthService>();
  final UserRepository _userRepo = Get.find();
  final RxBool _isLoading = false.obs;
  final List<int> _delays = [];
  final TextEditingController _passwordController = TextEditingController();
  final Rxn<AppUser> currentAppUser = Rxn<AppUser>();

  Future<void> _refreshUsers() async {
    try {
      _isLoading.value = true;
      await _userRepo.getAllUsers().first;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();

    final firebaseUser = authService.auth.currentUser;
    if (firebaseUser != null) {
      _userRepo.getUser(firebaseUser.uid).then((user) {
        currentAppUser.value = user;
      });
    }

    // Delay setup for animations
    _userRepo.getAllUsers().first.then((users) {
      setState(() {
        _delays.clear();
        for (int i = 0; i < users.length; i++) {
          _delays.add(i * 100);
        }
      });
    });
  }

  // Future<void> _deleteAccount() async {
  //   try {
  //     final password = await _showPasswordDialog();
  //     if (password.isEmpty) return;

  //     await authService.deleteAccount(
  //       password,
  //     );
  //     Get.offAll(() => const LoginPage());
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }
  Future<void> _deleteAccount() async {
    try {
      final password = await _showPasswordDialog();
      if (password.isEmpty) return;

      await authService.deleteAcc(
        email: authService.auth.currentUser?.email ?? '',
        password: password,
      );
      Get.offAll(() => const LoginPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', _parseAuthError(e));
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete account: ${e.toString()}');
    }
  }

  String _parseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'requires-recent-login':
        return 'Please re-login before deleting account';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return e.message ?? 'Account deletion failed';
    }
  }

  Future<String> _showPasswordDialog() async {
    _passwordController.clear();
    String? result = await Get.dialog(
      AlertDialog(
        title: const Text(
          'Confirm Deletion',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        // content: TextField(
        //   controller: _passwordController,
        //   obscureText: true,
        //   decoration: InputDecoration(
        //     contentPadding: EdgeInsets.all(10),
        //     labelText: 'Enter your password',
        //     labelStyle: TextStyle(fontSize: 14),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        //   ),
        // ),
        content: CustomFormField(
          isVisible: false,
          hintText: 'Password',
          controller: _passwordController,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (_passwordController.text.isNotEmpty) {
                Get.back(result: _passwordController.text);
              }
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return result ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => authService.signOut(),
            icon: Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: _userRepo.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return Obx(
            () => RefreshIndicator(
              onRefresh: _refreshUsers,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _isLoading.value ? users.length + 1 : users.length,
                  itemBuilder: (context, index) {
                    if (_isLoading.value && index == 0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final user = users[_isLoading.value ? index - 1 : index];
                    final delay =
                        _isLoading.value
                            ? 0
                            : (_delays.length > index ? _delays[index] : 0);

                    return FadeInUp(
                      from: 20,
                      duration: const Duration(milliseconds: 500),
                      delay: Duration(milliseconds: delay),
                      child: UserCard(user: user),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      drawer: Obx(() {
        final user = currentAppUser.value;

        return Drawer(
          child: CustomDrawer(
            backgroundImage:
                (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
                    ? NetworkImage(user.photoUrl!)
                    : AssetImage('assets/images/user.jpg'),
            email: user?.email,
            photoUrl: user?.photoUrl,
            userName: user?.name,
            child: Column(
              children: [
                DrawerTile(
                  title: 'Edit Profile',
                  icon: 'assets/icons/edit.svg',
                  onTap: () => Get.to(() => EditProfilePage()),
                  txtColor: Colors.black,
                  iconColor: Colors.black,
                  bgColor: Colors.grey.withAlpha(20),
                ),
                DrawerTile(
                  title: 'Sign Out',
                  icon: 'assets/icons/exit.svg',
                  onTap: () => authService.signOut(),
                  txtColor: Colors.black,
                  iconColor: Colors.black,
                  bgColor: Colors.grey.withAlpha(20),
                ),
                DrawerTile(
                  title: 'Delete Account',
                  icon: 'assets/images/delete.svg',
                  onTap: _deleteAccount,
                  txtColor: Colors.red,
                  iconColor: Colors.red,
                  bgColor: Colors.red.withAlpha(20),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
