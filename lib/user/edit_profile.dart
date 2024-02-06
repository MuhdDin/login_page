import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/image_picker/image_picker.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/select_image_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_button.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';
import '../provider/rebuild_notifier.dart';

class EditPage extends ConsumerStatefulWidget {
  const EditPage({super.key, required this.userName, required this.uidString});

  final String userName;
  final String uidString;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends ConsumerState<EditPage> {
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();
  TextEditingController instagram = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController twitter = TextEditingController();
  TextEditingController twitch = TextEditingController();
  TextEditingController youtube = TextEditingController();
  TextEditingController facebook = TextEditingController();
  late List? profileFileName = [];
  late List? bgFileName = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: appstyle(
            20,
            AppConst.kLight,
            FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
          future: StoreFirebase().fetchUserDatabyName(widget.userName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              UserInfoOri? userInfo = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  editProfilePictureAndBg(userInfo!),
                  Expanded(
                      child: SingleChildScrollView(
                    child: editUserInfo(userInfo),
                  )),
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Widget editProfilePictureAndBg(UserInfoOri userInfo) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(imageServiceProvider);
      return Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              bgFileName = await SelectImage().selectImage(ref);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConst.kRadius),
                ),
                image: DecorationImage(
                    image: bgFileName!.isEmpty
                        ? NetworkImage(userInfo.backgroundImage!)
                        : MemoryImage(base64Decode(bgFileName![0]))
                            as ImageProvider<Object>,
                    fit: BoxFit.cover),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConst.kRadius),
                ),
                color: Colors.black.withOpacity(0.4),
              ),
              child: const Text(''),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: const Color.fromARGB(184, 0, 0, 0),
                    spreadRadius: 10.h)
              ],
            ),
            child: GestureDetector(
              onTap: () async {
                profileFileName = await SelectImage().selectImage(ref);
              },
              child: CircleAvatar(
                radius: 55.w,
                backgroundColor: AppConst.kGreyLight,
                child: CircleAvatar(
                  radius: 50.w,
                  backgroundImage: profileFileName!.isEmpty
                      ? NetworkImage(userInfo.profilePicture!)
                      : MemoryImage(base64Decode(profileFileName![0]))
                          as ImageProvider<Object>,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget editUserInfo(UserInfoOri userInfo) {
    username.text = userInfo.userName;
    bio.text = userInfo.bio ?? '';
    email.text = userInfo.email;
    return Padding(
      padding: EdgeInsets.all(20.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'username',
              controller: username,
              prefixIcon: const Icon(Icons.person),
              obscureText: false,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Bio',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Bio',
              controller: bio,
              prefixIcon: const Icon(Icons.badge),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Email',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Email',
              controller: email,
              prefixIcon: const Icon(Icons.email),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Instagram',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Instagram',
              controller: instagram,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: const FaIcon(FontAwesomeIcons.instagram),
              ),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Twitter',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Twitter',
              controller: twitter,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: const FaIcon(FontAwesomeIcons.twitter),
              ),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Faceook',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Facebook',
              controller: facebook,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: const FaIcon(FontAwesomeIcons.facebook),
              ),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Twitch',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Twitch',
              controller: twitch,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: const FaIcon(FontAwesomeIcons.twitch),
              ),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 10.h),
          Text(
            'Youtube',
            style: appstyle(16, AppConst.kGreyLight, FontWeight.w400),
          ),
          HeightSpacer(hieght: 10.h),
          CustomTextField(
              hintText: 'Youtube',
              controller: youtube,
              prefixIcon: Padding(
                padding: EdgeInsets.all(10.0.w),
                child: const FaIcon(FontAwesomeIcons.squareYoutube),
              ),
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              color: AppConst.kLight),
          HeightSpacer(hieght: 20.h),
          Center(
            child: CustomButton(
              onTap: () async {
                print("clicked edit");
                String usernameValue =
                    username.text.isEmpty ? widget.userName : username.text;

                await StoreFirebase().editUser(
                  widget.userName,
                  usernameValue,
                  email.text,
                  0,
                  0,
                  widget.uidString,
                  bio.text,
                  bgImage: bgFileName!.isNotEmpty ? bgFileName![1] : null,
                  fileName:
                      profileFileName!.isNotEmpty ? profileFileName![1] : null,
                );
                ref.read(rebuildNotifierProvider.notifier).triggerRebuild();
                ref
                    .read(usernameStateProvider.notifier)
                    .setUsername(usernameValue);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              width: 0.5,
              height: 40.h,
              text: 'Submit',
              borderColor: AppConst.kLight,
              style: appstyle(16, AppConst.kLight, FontWeight.w500),
            ),
          ),
          HeightSpacer(hieght: 15.h)
        ],
      ),
    );
  }
}
