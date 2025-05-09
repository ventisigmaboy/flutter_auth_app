import 'package:cloud_firestore/cloud_firestore.dart';

// class User {
//   final String name;
//   final String id;
//   final String email;
//   final int age;

//   User({
//     required this.id,
//     required this.email,
//     required this.name,
//     required this.age,
//   });

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'name': name, 'email': email, 'age': age};
//   }

//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       id: map['id'] ?? '',
//       email: map['email'] ?? '',
//       name: map['name'] ?? '',
//       age: map['age']?.toInt() ?? 0,
//     );
//   }

//   factory User.fromFirebase(UserCredential credential, {String name = '', int age = 0}) {
//     return User(
//       id: credential.user?.uid ?? '',
//       email: credential.user?.email ?? '',
//       name: name,
//       age: age,
//     );
//   }
// }

// class AppUser {
//   final String uid;
//   final String? email;
//   final String? displayName;
//   final String? photoUrl;
//   final DateTime? creationTime;
//   final DateTime? lastSignInTime;
//   final bool isEmailVerified;

//   AppUser({
//     required this.uid,
//     this.email,
//     this.displayName,
//     this.photoUrl,
//     this.creationTime,
//     this.lastSignInTime,
//     this.isEmailVerified = false,
//   });

//   // Factory constructor to create AppUser from Firebase User
//   factory AppUser.fromFirebaseUser(User user) {
//     return AppUser(
//       uid: user.uid,
//       email: user.email,
//       displayName: user.displayName,
//       photoUrl: user.photoURL,
//       creationTime: user.metadata.creationTime,
//       lastSignInTime: user.metadata.lastSignInTime,
//       isEmailVerified: user.emailVerified,
//     );
//   }

//   // Convert to Map for storage or serialization
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'email': email,
//       'displayName': displayName,
//       'photoUrl': photoUrl,
//       'creationTime': creationTime?.toIso8601String(),
//       'lastSignInTime': lastSignInTime?.toIso8601String(),
//       'isEmailVerified': isEmailVerified,
//     };
//   }

//   // Create from Map (for deserialization)
//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       uid: map['uid'],
//       email: map['email'],
//       displayName: map['displayName'],
//       photoUrl: map['photoUrl'],
//       creationTime: map['creationTime'] != null 
//           ? DateTime.parse(map['creationTime']) 
//           : null,
//       lastSignInTime: map['lastSignInTime'] != null
//           ? DateTime.parse(map['lastSignInTime'])
//           : null,
//       isEmailVerified: map['isEmailVerified'] ?? false,
//     );
//   }

//   // Empty user
//   static AppUser get empty => AppUser(uid: '');

//   static Stream<List<AppUser>> fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {}
// }

class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final bool isVerified;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    this.isVerified = false,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? data['displayName'] ?? 'No Name',
      photoUrl: data['photoUrl'] ?? data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'isVerified': isVerified,
    };
  }
}