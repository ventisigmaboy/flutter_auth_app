// services/user_repository.dart
import 'package:auth_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Get single user
  Future<AppUser?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? AppUser.fromFirestore(doc) : null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get user data');
      return null;
    }
  }

  // Get all users (for displaying cards)
  Stream<List<AppUser>> getAllUsers() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList(),
        );
  }

  // Create/update user
  Future<void> saveUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }
}
