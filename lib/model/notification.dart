class NotificationModel {
  final String type;
  final DateTime createdAt;
  String? postId;
  final String uid;
  final String description;

  NotificationModel({
    required this.type,
    required this.createdAt,
    this.postId,
    required this.uid,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'type': type,
      'createdAt': createdAt,
      'uid': uid,
      'description': description,
    };
    if (postId != null) {
      map['postId'] = postId;
    }
    return map;
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
