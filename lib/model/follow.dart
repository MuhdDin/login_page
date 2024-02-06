import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingUser {
  final String uid;
  final String username;
  DateTime? createdAt;

  FollowingUser({required this.uid, required this.username, this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'uid': uid,
      'username': username,
    };
  }

  factory FollowingUser.fromMap(Map<String, dynamic> map) {
    return FollowingUser(
      uid: map['uid'],
      username: map['username'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
