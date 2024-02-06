import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/calculate_day.dart';
import 'package:login_page/model/comments.dart';
import 'package:login_page/model/notification.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/comment_provider.dart';
import 'package:login_page/provider/like_provider.dart';
import 'package:login_page/provider/notification_provider.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/user/user_page.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:login_page/widget/widthspacer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

class ShowPosts extends ConsumerStatefulWidget {
  const ShowPosts(
      {super.key,
      required this.username,
      required this.heightMultiplier,
      this.imageIndex,
      required this.page});

  final String username;
  final double heightMultiplier;
  final int? imageIndex;
  final String page;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<ShowPosts> {
  TextEditingController commentController = TextEditingController();
  ItemScrollController scrollController = ItemScrollController();
  String userPostId = '';

  @override
  Widget build(BuildContext context) {
    return userPostImage(widget.username);
  }

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
  }

  Widget userPostImage(String username) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: SizedBox(
        height: AppConst.kHeight * widget.heightMultiplier,
        child: FutureBuilder(
          future: (widget.page == 'homepage')
              ? StoreFirebase().fetchPostData()
              : StoreFirebase().fetchPostDataByUsername(username),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('no connection');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: double.infinity,
                            color: AppConst.kLight,
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
                  List<ImagePost>? userdata = snapshot.data;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollController.jumpTo(index: widget.imageIndex ?? 0);
                  });
                  return SizedBox(
                    child: ScrollablePositionedList.builder(
                      itemScrollController: scrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: userdata!.length,
                      itemBuilder: (context, index) {
                        String name = ref.watch(usernameStateProvider);
                        userPostId = userdata[index].id!;
                        print('comment userID $userPostId');
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: StoreFirebase().fetchUserDatabyName(
                                  userdata[index].userName),
                              builder: (context, userSnapshot) {
                                switch (userSnapshot.connectionState) {
                                  case ConnectionState.none:
                                    return const Text('no connection');
                                  case ConnectionState.active:
                                  case ConnectionState.waiting:
                                    // Return a loading indicator or placeholder
                                    return Container();
                                  case ConnectionState.done:
                                    if (userSnapshot.hasError) {
                                      return Text(
                                          'Error ${userSnapshot.error}');
                                    } else {
                                      UserInfoOri? userData2 =
                                          userSnapshot.data;
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            10.w, 0, 0, 2.h),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  int role = 0;
                                                  if (name !=
                                                      userData2.userName) {
                                                    role = 1;
                                                  }
                                                  print(
                                                      'clicked ${userData2.userName}, $role');
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UserPage(
                                                        userName:
                                                            userData2.userName,
                                                        role: role,
                                                        userId: userData2.uid!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: userData2!
                                                              .profilePicture!
                                                              .isNotEmpty
                                                          ? NetworkImage(userData2
                                                              .profilePicture!)
                                                          : const AssetImage(
                                                                  'assets/image/userIcon.png')
                                                              as ImageProvider,
                                                    ),
                                                    WidthSpacer(width: 20.w),
                                                    Text(
                                                      userdata[index].userName,
                                                      style: appstyle(
                                                          15,
                                                          AppConst.kLight,
                                                          FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 8.0.w),
                                                child: const Icon(
                                                  Icons.more_vert,
                                                  color: AppConst.kGreyLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                }
                              },
                            ),
                            const HeightSpacer(hieght: 10),
                            CachedNetworkImage(
                              imageUrl: userdata[index].imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: AppConst.kHeight *
                                  0.5, // Adjust the height as needed
                            ),
                            likeShareComment(username, userdata[index].id!,
                                userdata[index].uid),
                            comment(userdata[index].userName,
                                userdata[index].caption),
                            GestureDetector(
                                onTap: () {},
                                child: previewComment(
                                    userdata[index].id!, userdata[index].uid)),
                            HeightSpacer(hieght: 40.h)
                          ],
                        );
                      },
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget previewComment(String id, String posterId) {
    return FutureBuilder(
      future: StoreFirebase().fetchPreviewComment(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // Handle the error condition
            return Text('Error: ${snapshot.error}');
          }

          UsersComments? data = snapshot.data;

          if (data != null) {
            return FutureBuilder(
              future: StoreFirebase().fetchUserDatabyUid(data.userId),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.done) {
                  if (userSnapshot.hasError) {
                    // Handle the error condition
                    return Text('Error: ${userSnapshot.error}');
                  }

                  UserInfoOri? userInfo = userSnapshot.data;

                  if (userInfo != null) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return showComment(userInfo.uid!, id, posterId);
                            });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          comment(userInfo.userName, data.comment),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0.w),
                            child: Text(
                              'show all comments',
                              style: appstyle(
                                  13, AppConst.kGreyLight, FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container(); // Loading state for userSnapshot
                }
              },
            );
          } else {
            return Container(); // Handle the case where data is null
          }
        } else {
          return Container(); // Loading state for snapshot
        }
      },
    );
  }

  Widget showComment(String userId, String postId, String posterId) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(commentServiceProvider);
      return FutureBuilder(
          future: StoreFirebase().fetchComment(postId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<UsersComments> data = snapshot.data!;
              return Builder(builder: (context) {
                if (data.isNotEmpty) {
                  return Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: AppConst.kBkDark,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConst.kRadius),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Comments',
                            style:
                                appstyle(20, AppConst.kLight, FontWeight.bold),
                          ),
                        ),
                        HeightSpacer(hieght: 10.h),
                        const Divider(
                          color: AppConst.kLight,
                        ),
                        HeightSpacer(hieght: 10.h),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                future: StoreFirebase()
                                    .fetchUserDatabyUid(data[index].userId),
                                builder: (context, commentSnapshot) {
                                  if (commentSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    UserInfoOri userData =
                                        commentSnapshot.data!;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userData.profilePicture!),
                                      ),
                                      title: Padding(
                                        padding: EdgeInsets.only(bottom: 2.0.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              userData.userName,
                                              style: appstyle(
                                                  10,
                                                  AppConst.kLight,
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              calculateDaysDifference(
                                                  data[index]
                                                      .createdAt
                                                      .toString()),
                                              style: appstyle(
                                                  10,
                                                  AppConst.kLight,
                                                  FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(
                                        data[index].comment,
                                        style: appstyle(12, AppConst.kGreyLight,
                                            FontWeight.normal),
                                      ),
                                    );
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: ListTile(
                                        leading: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Container(
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                        subtitle: Container(
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.h), // Adjust the height as needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                style: appstyle(
                                    12, AppConst.kLight, FontWeight.normal),
                                hintStyle: appstyle(
                                    12, AppConst.kLight, FontWeight.normal),
                                hintText: 'Enter comment',
                                controller: commentController,
                                obscureText: false,
                                color: AppConst.kBkLight,
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    String textComment = commentController.text;
                                    commentController.clear();
                                    ref
                                        .read(commentServiceProvider.notifier)
                                        .newComment(
                                          UsersComments(
                                              createdAt: DateTime.now(),
                                              comment: commentController.text,
                                              userId: userId),
                                        );

                                    await StoreFirebase().commentImage(
                                        UsersComments(
                                            createdAt: DateTime.now(),
                                            userId: userId,
                                            comment: textComment),
                                        postId);
                                    if (userId != posterId) {
                                      ref
                                          .read(rebuildNotificationProvider
                                              .notifier)
                                          .setNotification();
                                      await StoreFirebase().createNotification(
                                          NotificationModel(
                                              type: 'comment',
                                              createdAt: DateTime.now(),
                                              postId: postId,
                                              uid: userId,
                                              description:
                                                  '${widget.username} has commented on your photo: \'$textComment\''),
                                          posterId);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppConst.kLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: AppConst.kBkDark,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppConst.kRadius),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Comments',
                            style:
                                appstyle(20, AppConst.kLight, FontWeight.bold),
                          ),
                        ),
                        HeightSpacer(hieght: 10.h),
                        const Divider(
                          color: AppConst.kLight,
                        ),
                        HeightSpacer(hieght: 10.h),
                        Expanded(
                          child: SizedBox(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.nights_stay_outlined,
                                    color: AppConst.kGreyLight,
                                  ),
                                  WidthSpacer(width: 10.w),
                                  Text(
                                    'No comments',
                                    style: appstyle(20, AppConst.kGreyLight,
                                        FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h), // Adjust the height as needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                style: appstyle(
                                    12, AppConst.kLight, FontWeight.normal),
                                hintStyle: appstyle(
                                    12, AppConst.kLight, FontWeight.normal),
                                hintText: 'Enter comment',
                                controller: commentController,
                                obscureText: false,
                                color: AppConst.kBkLight,
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    String textComment = commentController.text;
                                    commentController.clear();
                                    ref
                                        .read(commentServiceProvider.notifier)
                                        .newComment(
                                          UsersComments(
                                              createdAt: DateTime.now(),
                                              comment: commentController.text,
                                              userId: userId),
                                        );
                                    await StoreFirebase().commentImage(
                                        UsersComments(
                                            createdAt: DateTime.now(),
                                            userId: userId,
                                            comment: textComment),
                                        postId);
                                    if (userId != posterId) {
                                      ref
                                          .read(rebuildNotificationProvider
                                              .notifier)
                                          .setNotification();
                                      await StoreFirebase().createNotification(
                                          NotificationModel(
                                              type: 'comment',
                                              createdAt: DateTime.now(),
                                              postId: postId,
                                              uid: userId,
                                              description:
                                                  '${widget.username} has commented on your photo: \'$textComment\''),
                                          posterId);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppConst.kLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              });
            } else {
              return Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: AppConst.kBkDark,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Comments',
                        style: appstyle(20, AppConst.kLight, FontWeight.bold),
                      ),
                    ),
                    HeightSpacer(hieght: 10.h),
                    const Divider(
                      color: AppConst.kLight,
                    ),
                    HeightSpacer(hieght: 10.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.white,
                              ),
                              title: Container(
                                height: 10,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                height: 10,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Expanded(
                    //       child: CustomTextField(
                    //         style:
                    //             appstyle(12, AppConst.kLight, FontWeight.normal),
                    //         hintStyle:
                    //             appstyle(12, AppConst.kLight, FontWeight.normal),
                    //         hintText: 'Enter comment',
                    //         controller: commentController,
                    //         obscureText: false,
                    //         color: AppConst.kBkLight,
                    //         suffixIcon: IconButton(
                    //           onPressed: () async {
                    //             commentController.clear();
                    //             await StoreFirebase().commentImage(
                    //                 UsersComments(
                    //                     createdAt: DateTime.now(),
                    //                     userId: userId,
                    //                     comment: commentController.text),
                    //                 postId);
                    //           },
                    //           icon: const Icon(
                    //             Icons.arrow_forward_ios,
                    //             color: AppConst.kLight,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              );
            }
          });
    });
  }

  Widget likeShareComment(String username, String id, String posterId) {
    String userUid = ref.watch(uidStateProvider);
    return FutureBuilder(
      future: StoreFirebase().fetchUserDatabyName(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserInfoOri? data = snapshot.data;
          return Consumer(
            builder: (context, ref, child) {
              return Padding(
                padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 5.h),
                child: SizedBox(
                  width: AppConst.kWidth * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FutureBuilder(
                            future: StoreFirebase().fetchLikeAndTotalLikesCount(
                              id,
                              data!.uid!,
                              ref,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> dataLike = snapshot.data!;
                                return LikeButton(
                                  onTap: (isLiked) async {
                                    if (isLiked) {
                                      ref
                                          .read(imageLikesProvider(id).notifier)
                                          .unlikeImage(data.uid!);
                                    } else {
                                      ref
                                          .read(imageLikesProvider(id).notifier)
                                          .likeImage(
                                              data.uid!,
                                              NotificationModel(
                                                  type: 'Like',
                                                  createdAt: DateTime.now(),
                                                  postId: id,
                                                  uid: userUid,
                                                  description:
                                                      '$username has liked your photo'),
                                              posterId,
                                              ref);
                                    }
                                    return !isLiked;
                                  },
                                  isLiked: dataLike['isLiked'],
                                  likeCount: dataLike['totalLikesCount'],
                                  likeCountAnimationDuration:
                                      const Duration(milliseconds: 0),
                                  animationDuration:
                                      const Duration(milliseconds: 1000),
                                  size: 30.w,
                                );
                              } else {
                                return LikeButton(
                                  size: 30.w,
                                  likeCount: 0,
                                );
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return showComment(data.uid!, id, posterId);
                                  });
                            },
                            child: FaIcon(
                              FontAwesomeIcons.comment,
                              color: AppConst.kLight,
                              size: 28.w,
                            ),
                          ),
                          Icon(
                            Icons.send,
                            color: AppConst.kLight,
                            size: 30.w,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget comment(String username, String caption) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.w, 2.h, 0, 5.h),
      child: Row(
        children: [
          Text(
            username,
            style: appstyle(13, AppConst.kLight, FontWeight.bold),
          ),
          WidthSpacer(width: 8.w),
          Text(
            caption,
            style: appstyle(15, AppConst.kLight, FontWeight.w400),
          )
        ],
      ),
    );
  }

  // String calculateDaysDifference(String commentDate) {
  //   DateTime currentDate = DateTime.now();
  //   DateTime commentDateTime = DateTime.parse(commentDate);

  //   int differenceInDays = currentDate.difference(commentDateTime).inDays;
  //   if (differenceInDays == 0) {
  //     return 'today';
  //   } else if (differenceInDays <= 31) {
  //     return '$differenceInDays days ago';
  //   } else if (differenceInDays <= 365) {
  //     int differenceInMonths = (differenceInDays / 30).floor();
  //     return '$differenceInMonths months ago';
  //   } else {
  //     int differenceInYears = (differenceInDays / 365).floor();
  //     return '$differenceInYears years ago';
  //   }
  // }
}
