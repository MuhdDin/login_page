import 'package:flutter/material.dart';
import 'package:login_page/constant/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.keyboardType,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.hintStyle,
    required this.controller,
    this.onChanged,
    this.validator,
    required this.obscureText,
    this.onSaved,
    this.provideKey,
    required this.color,
    this.style,
    this.maxLines,
    this.initialValue,
  });

  final TextInputType? keyboardType;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextStyle? hintStyle;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final Key? provideKey;
  final Color color;
  final TextStyle? style;
  final int? maxLines;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConst.kWidth * 0.9,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(AppConst.kRadius),
        ),
        color: color,
      ),
      child: TextFormField(
        initialValue: initialValue,
        key: provideKey,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        cursorHeight: 25,
        obscureText: obscureText,
        onChanged: onChanged,
        onSaved: onSaved,
        style: style,
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          hintText: hintText,
          suffixIcon: suffixIcon,
          focusColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIconColor: AppConst.kBkDark,
          hintStyle: hintStyle,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kRed,
              width: 0.5,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.5,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kRed,
              width: 0.5,
            ),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kGreyDk,
              width: 0.5,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: AppConst.kBkDark,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
