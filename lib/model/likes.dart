import 'package:cloud_firestore/cloud_firestore.dart';

class LikeImage {
  final String userId;
  final DateTime createdAt;
  LikeImage({required this.createdAt, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory LikeImage.fromMap(Map<String, dynamic> map) {
    return LikeImage(
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      userId: map['userId'],
    );
  }
}
