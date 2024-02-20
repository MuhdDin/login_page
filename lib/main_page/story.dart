import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:login_page/widget/widthspacer.dart';

class StoryPost extends StatefulWidget {
  const StoryPost({Key? key});

  @override
  State<StoryPost> createState() => _StoryPostState();
}

class _StoryPostState extends State<StoryPost> with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController controller;
  int currentIndex = 0; // Index of the current example post
  List<String> examplePosts = [
    "assets/image/bigraga.jpeg",
    "assets/image/userIcon.png"
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer(const Duration(seconds: 5), () {
      // Check if there are more example posts
      if (currentIndex < examplePosts.length - 1) {
        setState(() {
          currentIndex++; // Move to the next example post
        });
        startTimer(); // Start the timer again for the next post
      } else {
        Navigator.pop(context); // No more example posts, navigate back
      }
    });
    // Start animation when timer starts
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            showStory(),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  linearProgress(),
                  HeightSpacer(hieght: 10.h),
                  posterInfo(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget linearProgress() {
    return LinearProgressIndicator(
      value: controller.value,
      semanticsLabel: 'Linear progress indicator',
      valueColor:
          const AlwaysStoppedAnimation<Color>(Colors.blue), // Change color here
      backgroundColor: Colors.grey[300],
    );
  }

  Widget posterInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 15.w,
          backgroundImage: const AssetImage("assets/image/userIcon.png"),
        ),
        WidthSpacer(width: 10.w),
        Text(
          "Muhammad Din",
          style: appstyle(12.w, AppConst.kLight, FontWeight.w400),
        ),
      ],
    );
  }

  Widget showStory() {
    return Container(
      height: AppConst.kHeight,
      width: AppConst.kWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            examplePosts[currentIndex], // Show current example post
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
