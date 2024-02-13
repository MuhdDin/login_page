import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String friendUid;
  final String messageType;
  final DateTime createdAt;
  final String message;
  final bool read;

  Chat({
    required this.friendUid,
    required this.messageType,
    required this.createdAt,
    required this.message,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'friendUid': friendUid,
      'createdAt': createdAt,
      'messageType': messageType,
      'message': message,
      'read': read
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
        friendUid: map['friendUid'],
        messageType: map['messageType'],
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        message: map['message'],
        read: map['read']);
  }
}
