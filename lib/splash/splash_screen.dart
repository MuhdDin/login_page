import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/check_login.dart';
import 'package:login_page/widget/appstyle.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: AppConst.kBkDark,
      splash: Container(
        color: AppConst.kLight,
        width: AppConst.kWidth,
        height: 200.h,
        child: Center(
          child: Text(
            "My Project",
            style: appstyle(40.h, AppConst.kBkDark, FontWeight.w500,
                fontFamily: FontFamily.pacifico),
          ),
        ),
      ),
      nextScreen: const AuthWrapper(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
