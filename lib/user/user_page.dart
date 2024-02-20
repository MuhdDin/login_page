import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset_box_shadow;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/auth.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/login_page/pages/login.dart';
import 'package:login_page/model/follow.dart';
import 'package:login_page/model/notification.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/addImage_provider.dart';
import 'package:login_page/provider/click_provider.dart';
import 'package:login_page/provider/rebuild_notifier.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/user/edit_profile.dart';
import 'package:login_page/user/user_post.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_button.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:shimmer/shimmer.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({
    super.key,
    required this.userName,
    required this.role,
    required this.userId,
  });

  final String userName;
  final int role;
  final String userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Tween<double> tween = Tween(begin: 1, end: 1);
  bool? isFollowing;
  String ownerId = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    name = ref.watch(usernameStateProvider);
    String truename = widget.role == 0 ? name : widget.userName;
    print("truename: $name");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          truename,
          style: appstyle(
            20,
            AppConst.kLight,
            FontWeight.w700,
          ),
        ),
        actions: [
          widget.role == 0
              ? Padding(
                  padding: EdgeInsets.only(right: 8.0.w),
                  child: GestureDetector(
                    onTap: () async {
                      await Authentication().signOut();
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const LoginPage();
                          },
                        ), (route) => false);
                      }
                    },
                    child: const Icon(
                      Icons.logout,
                      color: AppConst.kLight,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          return Center(
            child: SafeArea(
              child: Column(
                children: [
                  userProfilePicture(context, truename, name),
                  const HeightSpacer(hieght: 20),
                  gridImageView(truename),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget userProfilePicture(
      BuildContext context, String username, String ownerName) {
    ref.watch(rebuildNotifierProvider);
    return FutureBuilder(
      future: StoreFirebase().fetchUserDatabyUid(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserInfoOri? data = snapshot.data;
          return SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConst.kRadius)),
                            image: DecorationImage(
                                image: NetworkImage(data!.backgroundImage!),
                                fit: BoxFit.cover),
                          ),
                          foregroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConst.kRadius)),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: const Text(''),
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
                          child: CircleAvatar(
                            radius: 55.w,
                            backgroundColor: AppConst.kGreyLight,
                            child: CircleAvatar(
                              radius: 50.w,
                              backgroundImage: data.profilePicture!.isNotEmpty
                                  ? NetworkImage(data.profilePicture!)
                                  : const AssetImage(
                                          'assets/image/userIcon.png')
                                      as ImageProvider,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.role == 0
                        ? Positioned(
                            top: 8,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      uidString: data.uid!,
                                      userName: data.userName,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: AppConst.kLight,
                                size: 20.w,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Builder(builder: (context) {
                  return followbutton(data.uid!, ownerName);
                }),
                userInfo(data.bio ?? '', data.followers!, data.following!),
              ],
            ),
          );
        } else {
          UserInfoOri? data2 = snapshot.data;
          return SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConst.kRadius)),
                            ),
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConst.kRadius)),
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
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CircleAvatar(
                              radius: 55.w,
                              backgroundColor: AppConst.kGreyLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.role == 0
                        ? Positioned(
                            top: 8,
                            right: 5,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      uidString: data2!.uid!,
                                      userName: data2.userName,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: AppConst.kLight,
                                size: 20.w,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                followbutton('', ownerName),
                HeightSpacer(hieght: 10.h),
                userInfo('', 0, 0),
              ],
            ),
          );
        }
      },
    );
  }

  void onButtonTap(FollowingUser ownerFollow, String ownerid,
      FollowingUser followedInfo, String followedId) async {
    tween = Tween(begin: 0.7, end: 1);
    _controller.forward(from: 0.0);
    ref.read(tapNotifierProvider.notifier).triggerRebuild();
    if (isFollowing == true) {
      isFollowing = !isFollowing!;
      await StoreFirebase().unfollowUser(ownerid, followedId);
    } else {
      isFollowing = !isFollowing!;
      await StoreFirebase()
          .followUser(ownerFollow, ownerid, followedInfo, followedId);
    }
  }

  Widget followbutton(String uid, String ownerName) {
    if (widget.role == 1) {
      ownerId = ref.watch(uidStateProvider);
      print('owener: $ownerId');
      return FutureBuilder(
        future: StoreFirebase().checkFollow(ownerId, uid),
        builder: (context, snapshot) {
          isFollowing = snapshot.data;
          print('isfollow: $isFollowing');
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer(
              builder: (context, ref, child) {
                ref.watch(tapNotifierProvider);
                return ScaleTransition(
                  scale: tween.animate(CurvedAnimation(
                      parent: _controller, curve: Curves.elasticOut)),
                  child: Column(
                    children: [
                      CustomButton(
                        backgroundColor: AppConst.kBkDark,
                        height: 35.h,
                        onTap: () async {
                          onButtonTap(
                              FollowingUser(
                                  uid: uid,
                                  username: widget.userName,
                                  createdAt: DateTime.now()),
                              ownerId,
                              FollowingUser(
                                  uid: ownerId,
                                  username: name,
                                  createdAt: DateTime.now()),
                              uid);
                          await StoreFirebase().createNotification(
                              NotificationModel(
                                  type: "follower",
                                  createdAt: DateTime.now(),
                                  uid: ownerId,
                                  description: "$ownerName has followed you"),
                              uid);
                        },
                        boxShadow: [
                          inset_box_shadow.BoxShadow(
                              blurRadius: isFollowing! ? 5 : 10,
                              offset: isFollowing!
                                  ? const Offset(-10, -10)
                                  : const Offset(-5, -5),
                              color: const Color.fromARGB(66, 171, 170, 170),
                              inset: isFollowing!),
                          inset_box_shadow.BoxShadow(
                              blurRadius: isFollowing! ? 5 : 10,
                              offset: isFollowing!
                                  ? const Offset(10, 10)
                                  : const Offset(5, 5),
                              color: Colors.black,
                              inset: isFollowing!),
                        ],
                        borderColor: Colors.transparent,
                        width: 0.35.w,
                        text: isFollowing! ? 'UnFollow' : 'Follow',
                        style: appstyle(14.w, AppConst.kLight, FontWeight.w300,
                            letterSpacing: 3),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CustomButton(
                  width: 0.35.w,
                  text: '',
                  style: appstyle(14.w, AppConst.kLight, FontWeight.w300,
                      letterSpacing: 3),
                  borderColor: AppConst.kBkDark,
                  height: 0.35.w),
            );
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  Widget userInfo(String bio, int followers, int following) {
    List<String> follow = ['Followers', 'Following'];
    List<int> followCount = [followers, following];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(9.0.h),
          child: Text(
            bio.isNotEmpty ? bio : '',
            style: appstyle(12, AppConst.kLight, FontWeight.w300),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < follow.length; i++)
              Column(
                children: [
                  Text(
                    follow[i],
                    style: appstyle(12, AppConst.kLight, FontWeight.w600),
                  ),
                  Text(
                    followCount[i].toString(),
                    style: appstyle(16, AppConst.kLight, FontWeight.w400),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget gridImageView(String username) {
    ref.watch(addImageNotifierProvider);
    return SizedBox(
      height: AppConst.kHeight * 0.6,
      child: FutureBuilder(
        future: StoreFirebase().fetchPostDataByUsername(username),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('no connection');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      child: Center(
                        child: Container(
                          color: const Color.fromARGB(83, 185, 185, 185),
                        ),
                      ),
                    );
                  },
                ),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              } else {
                List<ImagePost>? data = snapshot.data;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemCount:
                      data!.length, // Adjust the number of items as needed
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserPost(index: index, username: username),
                          ),
                        );
                      },
                      child: SizedBox(
                        child: CachedNetworkImage(
                          imageUrl: data[index].imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
