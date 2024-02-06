import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/auth.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/image_picker/image_picker.dart';
import 'package:login_page/provider/select_image_provider.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/background_particle.dart';
import 'package:login_page/widget/custom_button.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool obscureText = true;
  String password2 = '';
  late List? fileName = [];

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String image = ref.watch(imageServiceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          'Sign In',
          style: appstyle(25, AppConst.kLight, FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const BackgroundParticle(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        "Upload your profile picture: ",
                        style: appstyle(17, AppConst.kLight, FontWeight.w500),
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        fileName = await SelectImage().selectImage(ref);
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: 55.w,
                              backgroundColor: AppConst.kLight,
                              backgroundImage: image.isNotEmpty
                                  ? MemoryImage(base64Decode(image))
                                  : const AssetImage(
                                          'assets/image/userIcon.png')
                                      as ImageProvider),
                          Icon(
                            Icons.add_a_photo,
                            size: 20.w,
                            color: AppConst.kGreyLight,
                          )
                        ],
                      ),
                    ),
                  ),
                  HeightSpacer(hieght: 30.h),
                  Text(
                    "Enter email: ",
                    style: appstyle(15, AppConst.kLight, FontWeight.w500),
                  ),
                  const HeightSpacer(hieght: 10),
                  Center(
                      child: CustomTextField(
                    hintText: 'email',
                    controller: email,
                    color: AppConst.kLight,
                    prefixIcon: const Icon(Icons.email),
                    obscureText: false,
                  )),
                  const HeightSpacer(hieght: 25),
                  Text(
                    "Enter password: ",
                    style: appstyle(15, AppConst.kLight, FontWeight.w500),
                  ),
                  const HeightSpacer(hieght: 10),
                  Center(
                    child: CustomTextField(
                      hintText: 'password',
                      controller: password,
                      maxLines: 1,
                      color: AppConst.kLight,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _toggle();
                        },
                        child: obscureText
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      validator: (val) =>
                          val!.length < 6 ? 'Password too short' : null,
                      onSaved: (val) => password2 = val!,
                      obscureText: obscureText,
                    ),
                  ),
                  const HeightSpacer(hieght: 25),
                  Text(
                    "Enter Name: ",
                    style: appstyle(15, AppConst.kLight, FontWeight.w500),
                  ),
                  const HeightSpacer(hieght: 10),
                  Center(
                    child: CustomTextField(
                      hintText: 'name',
                      controller: name,
                      color: AppConst.kLight,
                      prefixIcon: const Icon(Icons.person),
                      obscureText: false,
                    ),
                  ),
                  const HeightSpacer(hieght: 30),
                  Center(
                    child: CustomButton(
                      onTap: () async {
                        String uid = await Authentication()
                            .createUser(email.text, password.text);
                        await StoreFirebase().createUser(
                            fileName![1], name.text, email.text, 0, 0, uid);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      width: 0.5,
                      height: 40.h,
                      text: 'Submit',
                      borderColor: AppConst.kLight,
                      style: appstyle(16, Colors.white, FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
