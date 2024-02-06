import 'package:flutter/material.dart';
import 'package:login_page/constant/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.onTap,
      required this.width,
      required this.text,
      required this.style,
      required this.borderColor,
      this.backgroundColor,
      this.boxShadow,
      required this.height});

  final void Function()? onTap;
  final double width;
  final double height;
  final String text;
  final TextStyle style;
  final Color borderColor;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppConst.kWidth * width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: backgroundColor,
          border: Border.all(width: 2, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(AppConst.kRadius)),
        ),
        child: Center(
          child: Text(
            text,
            style: style,
          ),
        ),
      ),
    );
  }
}
