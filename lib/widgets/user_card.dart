import 'package:auth_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final AppUser user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: Colors.black.withAlpha(20),
      ),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade500,
          backgroundImage:
              user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child:
              user.photoUrl == null
                  ? const Icon(Icons.person, color: Colors.black)
                  : null,
        ),
        title: Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(user.email),
      ),
    );
  }
}