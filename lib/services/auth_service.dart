import 'package:auth_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Convert current user to AppUser
  // AppUser? get currentUser {
  //   final user = auth.currentUser;
  //   return user != null ? AppUser.fromFirebaseUser(user) : null;
  // }

  // Stream of AppUser instead of Firebase User
  // Stream<AppUser?> get authStateChanges {
  //   return auth.authStateChanges().map((user) {
  //     return user != null ? AppUser.fromFirebaseUser(user) : null;
  //   });
  // }

  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<User?> createAccountWithProfile({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1. Create auth account
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Update display name
      await userCredential.user?.updateDisplayName(name);

      // 3. Create Firestore document
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'isVerified': false,
      });

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    Get.offAll(() => AuthWrapper());
  }

  Future<void> deleteAcc({
    required String email,
    required String password,
  }) async {
    final user = auth.currentUser;
    if (user == null) throw "No user logged in";

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
    } catch (e) {
      debugPrint("Error deleting user document: $e");
    }

    await user.delete();

    await auth.signOut();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? photoUrl,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw "No user logged in";

      // Update Auth profile
      await user.updateDisplayName(name);
      if (email != user.email) {
        await user.verifyBeforeUpdateEmail(email);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw _parseAuthError(e);
    } catch (e) {
      throw "Profile update failed: ${e.toString()}";
    }
  }

  String _parseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'requires-recent-login':
        return 'Please re-login to update email';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email format';
      default:
        return e.message ?? 'Profile update failed';
    }
  }

  // Future<void> deleteAccount(String currentPassword) async {
  //   try {
  //     final user = auth.currentUser;
  //     if (user == null) throw "No user logged in";

  //     final credential = EmailAuthProvider.credential(
  //       email: user.email!,
  //       password: currentPassword,
  //     );
  //     await user.reauthenticateWithCredential(credential);

  //     await user.delete();

  //     await auth.signOut();
  //   } catch (e) {
  //     throw "Failed to delete account: ${e.toString()}";
  //   }
  // }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class AuthService extends GetxService {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   User? get currentUser => auth.currentUser;

//   Stream<User?> get authStateChanges => auth.authStateChanges();

//   Future<UserCredential> signIn({
//     required String email,
//     required String password,
//   }) async {
//     return await auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   Future<UserCredential> createAcc({
//     required String email,
//     required String password,
//   }) async {
//     return await auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   Future<void> signOut() async {
//     await auth.signOut();
//   }

//   Future<void> deleteAcc({
//     required String email,
//     required String password,
//   }) async {
//     AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
//     await currentUser!.reauthenticateWithCredential(credential);
//     await currentUser!.delete();
//     await auth.signOut();
//   }
// }
