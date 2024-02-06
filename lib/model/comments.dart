import 'package:cloud_firestore/cloud_firestore.dart';

class UsersComments {
  final String userId;
  final String comment;
  final DateTime createdAt;
  UsersComments(
      {required this.createdAt, required this.comment, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory UsersComments.fromMap(Map<String, dynamic> map) {
    return UsersComments(
      comment: map['comment'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userId: map['userId'],
    );
  }
}
