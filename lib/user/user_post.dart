import 'package:flutter/material.dart';
import 'package:login_page/widget/show_post.dart';

class UserPost extends StatefulWidget {
  const UserPost({super.key, required this.index, required this.username});
  final int index;
  final String username;

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ShowPosts(
          username: widget.username,
          heightMultiplier: 0.9,
          imageIndex: widget.index,
          page: 'userpage',
        ),
      ),
    );
  }
}
