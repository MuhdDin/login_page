import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoOri {
  final String userName;
  final String email;
  DateTime? createdAt;
  String? profilePicture;
  String? backgroundImage;
  String? bio;
  String? instagram;
  String? twitter;
  String? twitch;
  String? youtube;
  String? facebook;
  String? uid;
  int? followers;
  int? following;

  UserInfoOri({
    this.createdAt,
    required this.email,
    required this.userName,
    this.bio,
    this.instagram,
    this.facebook,
    this.twitter,
    this.twitch,
    this.youtube,
    this.uid,
    this.profilePicture,
    this.followers,
    this.following,
    this.backgroundImage,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'createdAt': createdAt,
      'userName': userName,
      'email': email,
      'bio': bio,
      'uid': uid,
      'followers': followers,
      'following': following,
    };

    // Add 'backgroundImage' to the map only if it's not null
    if (backgroundImage != null) {
      map['backgroundImage'] = backgroundImage;
    }
    if (profilePicture != null) {
      map['profilePicture'] = profilePicture;
    }

    return map;
  }

  factory UserInfoOri.fromMap(Map<String, dynamic> map) {
    return UserInfoOri(
        createdAt: (map['createdAt'] as Timestamp).toDate(),
        userName: map['userName'],
        email: map['email'],
        profilePicture: map['profilePicture'],
        uid: map['uid'],
        bio: map['bio'],
        backgroundImage: map['backgroundImage'],
        followers: map['followers'],
        following: map['following']);
  }
}
