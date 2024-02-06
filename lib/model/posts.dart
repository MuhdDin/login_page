class ImagePost {
  final String uid;
  final String userName;
  String? id;
  final String caption;
  final String address;
  final DateTime date;
  final String imageUrl;

  ImagePost({
    required this.uid,
    required this.userName,
    this.id,
    required this.caption,
    required this.address,
    required this.date,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'caption': caption,
      'id': id,
      'address': address,
      'date': date,
      'imageUrl': imageUrl,
    };
  }

  factory ImagePost.fromMap(Map<String, dynamic> map) {
    return ImagePost(
      uid: map['uid'],
      userName: map['userName'],
      caption: map['caption'],
      id: map['id'],
      address: map['address'],
      date: map['date'].toDate(), // Assuming date is stored as a timestamp
      imageUrl: map['imageUrl'],
    );
  }
}
