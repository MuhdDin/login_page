import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_page/add/add_page.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/main_page/chat/chat_page.dart';
import 'package:login_page/main_page/story.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/read_message_provider.dart';
import 'package:login_page/provider/rebuild_notifier.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/user/user_page.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:login_page/widget/show_post.dart';
import 'package:login_page/widget/widthspacer.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();

  List<UserInfoOri> userData = [];
  List<Map<String, dynamic>> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<void> loadComments() async {
    final String commentsJson =
        await rootBundle.loadString('assets/data/comment.json');
    final List<dynamic> commentsList = json.decode(commentsJson);

    setState(() {
      comments = List<Map<String, dynamic>>.from(commentsList);
    });
  }

  void rebuildHomePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String uid = ref.watch(uidStateProvider);
    ref.watch(rebuildNotifierProvider);
    return FutureBuilder(
        future: Future.delayed(
            Duration.zero, () => ref.watch(usernameStateProvider)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String username = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: AppConst.kLight,
                centerTitle: false,
                title: Text('My project', style: GoogleFonts.pacifico()),
                actions: [
                  Stack(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const ChatPage()),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat)),
                      Consumer(
                        builder: (context, ref, child) {
                          ref.watch(readMessageProvider);
                          return StreamBuilder<UserInfoOri>(
                            stream: StoreFirebase().streamUserDataByUid(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Show a loading indicator while waiting for data
                                return CircularProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                // When data is actively being received
                                if (snapshot.hasData) {
                                  // If data is available
                                  UserInfoOri data = snapshot.data!;
                                  return Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppConst.kRadius),
                                        color: data.unreadMessage! > 0
                                            ? AppConst.kRed
                                            : Colors.transparent,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2.0.w, horizontal: 3.w),
                                        child: data.unreadMessage! > 0
                                            ? Text(
                                                data.unreadMessage.toString(),
                                                style: appstyle(
                                                    12.w,
                                                    AppConst.kLight,
                                                    FontWeight.w600),
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                } else {
                                  // If no data is available
                                  return const Text('No data available');
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                // If the stream has emitted all its data
                                return const Text('Stream completed');
                              } else {
                                // Handle other connection states
                                return Text(
                                    'Connection state: ${snapshot.connectionState}');
                              }
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // storyPost(username),
                    // WidthSpacer(width: 10.w),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: 100.h,
                        width: AppConst.kWidth,
                        child: Align(
                          alignment: Alignment.center,
                          child: friendsStory(username),
                        ),
                      ),
                    ),
                    HeightSpacer(hieght: 5.h),
                    SingleChildScrollView(
                      child: ShowPosts(
                        username: username,
                        heightMultiplier: 0.6.h,
                        page: 'homepage',
                        shuffle: true,
                      ),
                    ),
                  ],
                ),
              ),
              // bottomNavigationBar:
              //     SafeArea(child: BottomNav(username: username)),
            );
          } else {
            return Container();
          }
        });
  }

  Widget addImage(BuildContext context, String username) {
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Container(
        height: 35.h,
        width: 35.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(AppConst.kRadius),
          ),
        ),
        child: FutureBuilder(
            future: StoreFirebase().fetchUserDatabyName(username),
            builder: (context, snapshot) {
              UserInfoOri? data = snapshot.data;
              return IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPage(data!.userName)),
                  );
                },
                icon: const Icon(Icons.add),
              );
            }),
      ),
    );
  }

  Widget userProfile(BuildContext context, String username) {
    return FutureBuilder(
      future: StoreFirebase().fetchUserDatabyName(username),
      builder: (context, snapshot) {
        UserInfoOri? data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserPage(
                            userName: data.userName,
                            userId: data.uid!,
                            role: 0,
                          )));
            },
            child: CircleAvatar(
              radius: 24.w,
              backgroundImage: NetworkImage(data!.profilePicture!),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(left: 0.0.w),
            child: GestureDetector(
              onTap: () {},
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 24.w,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget storyPost(String username) {
    return FutureBuilder(
      future: StoreFirebase().fetchUserDatabyName(username),
      builder: (context, snapshot) {
        UserInfoOri? data = snapshot.data;
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: 80.w,
            height: 80.h,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const StoryPost()),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 45.w,
                    backgroundColor: AppConst.kGreyLight,
                    child: CircleAvatar(
                        radius: 35.w,
                        backgroundImage: NetworkImage(data!.profilePicture!)),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox(
            width: 80.w,
            height: 80.h,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CircleAvatar(
                      radius: 45.w,
                      backgroundColor: AppConst.kGreyLight,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  Widget friendsStory(String username) {
    return FutureBuilder(
      future: StoreFirebase().fetchUserData(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<UserInfoOri> data = snapshot.data!;
          data.insert(0, UserInfoOri(email: "", userName: username));
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return storyPost(username);
              } else {}
              return SizedBox(
                width: 80.w,
                height: 80.h,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => const StoryPost()),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 45.w,
                    backgroundColor: AppConst.kGreyLight,
                    child: CircleAvatar(
                        radius: 35.w,
                        backgroundImage:
                            NetworkImage(data[index].profilePicture!)),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                WidthSpacer(width: 10.w),
          );
        } else {
          return GestureDetector(
            onTap: () async {},
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                radius: 45.w,
                backgroundColor: AppConst.kGreyLight,
              ),
            ),
          );
        }
      }),
    );
  }
}
