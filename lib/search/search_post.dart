import 'package:flutter/material.dart';
import 'package:login_page/widget/show_post.dart';

class SearchPost extends StatefulWidget {
  const SearchPost({super.key, required this.username});

  final String username;

  @override
  State<SearchPost> createState() => _SearchPostState();
}

class _SearchPostState extends State<SearchPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ShowPosts(
          username: widget.username,
          heightMultiplier: 0.9,
          page: "searchPage",
        ),
      ),
    );
  }
}
