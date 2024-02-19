import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/notification.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/rebuild_notifier.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String userUid = ref.watch(uidStateProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Text(
                  'New',
                  style: appstyle(30.h, AppConst.kLight, FontWeight.w600),
                ),
              ),
              newNotification(userUid, false),
              Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Text(
                  'Older',
                  style: appstyle(30.h, AppConst.kLight, FontWeight.w600),
                ),
              ),
              newNotification(userUid, true),
            ],
          ),
        ),
      ),
    );
  }

  Widget newNotification(String uid, bool old) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(rebuildNotifierProvider);
      return FutureBuilder(
        future: old
            ? StoreFirebase().fetchOldNotification(uid)
            : StoreFirebase().fetchNotification(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<NotificationModel> notifications = snapshot.data!;
            if (notifications.isEmpty) {
              return Container(
                padding: EdgeInsets.only(left: 10.0.w),
                height: 100.h,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.nights_stay_outlined,
                        color: const Color.fromARGB(100, 181, 182, 182),
                        size: 40.h,
                      ),
                      Text(
                        'No Notifications',
                        style: appstyle(14.w, AppConst.kLight, FontWeight.w400),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  if (notifications[index].type == "follower") {
                    return FutureBuilder(
                        future: StoreFirebase()
                            .fetchUserDatabyUid(notifications[index].uid),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.done) {
                            UserInfoOri userInfo = userSnapshot.data!;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userInfo.profilePicture!),
                              ),
                              title: Text(
                                notifications[index].description,
                                style: appstyle(
                                    14.h, AppConst.kLight, FontWeight.w400),
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
                                trailing: Container(
                                  width: 50.w,
                                  height: 55.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppConst.kRadius),
                                    ),
                                  ),
                                ),
                                title: Container(
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        });
                  } else {
                    return FutureBuilder(
                        future: StoreFirebase()
                            .fetchUserDatabyUid(notifications[index].uid),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.done) {
                            UserInfoOri userInfo = userSnapshot.data!;
                            return FutureBuilder(
                                future: StoreFirebase().fetchPostDataById(
                                    notifications[index].postId!),
                                builder: (context, postSnapshot) {
                                  if (postSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    ImagePost postData = postSnapshot.data!;
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userInfo.profilePicture!),
                                      ),
                                      trailing: Container(
                                        width: 50.w,
                                        height: 55.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(AppConst.kRadius),
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(postData.imageUrl),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        notifications[index].description,
                                        style: appstyle(14.h, AppConst.kLight,
                                            FontWeight.w400),
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
                                        trailing: Container(
                                          width: 50.w,
                                          height: 55.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(AppConst.kRadius),
                                            ),
                                          ),
                                        ),
                                        title: Container(
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                });
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                ),
                                trailing: Container(
                                  width: 50.w,
                                  height: 55.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(AppConst.kRadius),
                                    ),
                                  ),
                                ),
                                title: Container(
                                  height: 10,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        });
                  }
                },
              );
            }
          } else {
            return Container();
          }
        },
      );
    });
  }

//   Widget oldNotification(String uid) {
//     return FutureBuilder(
//       future: StoreFirebase().fetchOldNotification(uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           List<NotificationModel> data = snapshot.data!;
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: data.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(
//                   data[index].description,
//                   style: appstyle(14.h, AppConst.kLight, FontWeight.w400),
//                 ),
//               );
//             },
//           );
//         } else {
//           return Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: ListTile(
//               leading: const CircleAvatar(
//                 backgroundColor: Colors.white,
//               ),
//               trailing: Container(
//                 width: 50.w,
//                 height: 55.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(AppConst.kRadius),
//                   ),
//                 ),
//               ),
//               title: Container(
//                 height: 10,
//                 color: Colors.white,
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
}
