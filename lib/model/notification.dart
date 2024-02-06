class NotificationModel {
  final String type;
  final DateTime createdAt;
  final String postId;
  final String uid;
  final String description;

  NotificationModel({
    required this.type,
    required this.createdAt,
    required this.postId,
    required this.uid,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'createdAt': createdAt,
      'postId': postId,
      'uid': uid,
      'description': description,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      type: map['type'],
      createdAt: map['createdAt'].toDate(),
      postId: map['postId'],
      uid: map['uid'],
      description: map['description'],
    );
  }
}
