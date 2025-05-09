import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final ImageProvider<Object>? backgroundImage;
  final String? email;
  final String? photoUrl;
  final String? userName;
  final Widget? child;
  final Widget? userPhoto;
  const CustomDrawer({
    super.key,
    this.backgroundImage,
    this.email,
    this.photoUrl,
    this.userName,
    this.child,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey.shade600,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: backgroundImage,
                  child: userPhoto,
                ),
                SizedBox(height: 10),
                Text(
                  userName ?? 'No Name',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email ?? 'No Email',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: child ?? const SizedBox(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}