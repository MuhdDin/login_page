import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/calculate_day.dart';
import 'package:login_page/model/chat.dart';
import 'package:login_page/provider/chat_provider.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/user/user_page.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:login_page/widget/widthspacer.dart';

class ChatRoom extends ConsumerStatefulWidget {
  const ChatRoom(
      {super.key,
      required this.profilePicture,
      required this.friendName,
      required this.friendUid});

  final String profilePicture;
  final String friendName;
  final String friendUid;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  TextEditingController chat = TextEditingController();
  final isSendEnabledProvider = StateProvider<bool>((ref) => false);
  @override
  Widget build(BuildContext context) {
    String ownerUid = ref.watch(uidStateProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppConst.kLight,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                WidthSpacer(width: 2.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => UserPage(
                            userName: widget.friendName,
                            role: 1,
                            userId: widget.friendUid)),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilePicture),
                  ),
                ),
                WidthSpacer(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.friendName,
                      style: appstyle(16, AppConst.kLight, FontWeight.w600),
                    ),
                    HeightSpacer(hieght: 6.h),
                    Text(
                      'Online',
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13.w),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            showChat(ownerUid),
            textFieldArea(ownerUid),
          ],
        ),
      ),
    );
  }

  // Widget showChat(String ownerUid) {
  //   return Expanded(
  //       child: FutureBuilder(
  //     future: StoreFirebase().fetchChat(ownerUid, widget.friendUid),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.done) {
  //         List<Chat> messages = snapshot.data ?? [];
  //         print("length: ${messages.length}");
  //         print(" test: ${messages.first}");
  //         // if (snapshot.connectionState == ConnectionState.waiting &&
  //         //     messages.isNotEmpty) {
  //         //   return buildLastMessage(messages.last);
  //         // }
  //         if (messages.isEmpty) {
  //           return Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(
  //                   Icons.sunny,
  //                   size: 50.h,
  //                   color: AppConst.kGreyLight,
  //                 ),
  //                 Text(
  //                   "Start chatting with your friend",
  //                   style: appstyle(
  //                     20.w,
  //                     AppConst.kLight,
  //                     FontWeight.w400,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         }

  //         // Check if there's a new message in the chat notifier
  //         if (ref.watch(chatNotifierProvider).friendUid == widget.friendUid) {
  //           messages.insert(
  //               0,
  //               ref.watch(
  //                   chatNotifierProvider)); // Insert new message at the beginning
  //         }
  //         return ListView.builder(
  //           reverse: true,
  //           itemCount: messages.length,
  //           itemBuilder: (context, index) {
  //             return Column(
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.only(
  //                       left: 14, right: 14, top: 10, bottom: 10),
  //                   child: Align(
  //                     alignment: (messages[index].messageType == "receive"
  //                         ? Alignment.topLeft
  //                         : Alignment.topRight),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(20),
  //                         color: (messages[index].messageType == "receive"
  //                             ? Colors.grey.shade200
  //                             : Colors.blue[200]),
  //                       ),
  //                       padding: EdgeInsets.all(10.w),
  //                       child: Text(
  //                         messages[index].message,
  //                         style: const TextStyle(fontSize: 15),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: (messages[index].messageType == "receive"
  //                       ? Alignment.topLeft
  //                       : Alignment.topRight),
  //                   child: Padding(
  //                     padding: EdgeInsets.only(
  //                         left: 14.0.w, right: 14.0.w, bottom: 5.h),
  //                     child: Text(
  //                       calculateDaysDifference(
  //                           messages[index].createdAt.toString()),
  //                       style: appstyle(
  //                           12.w, AppConst.kGreyLight, FontWeight.w200),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       } else {
  //         return Container();
  //       }
  //     },
  //   ));
  // }
  Widget showChat(String ownerUid) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: StoreFirebase().streamChat(ownerUid, widget.friendUid),
        builder: (context, snapshot) {
          print("stream");
          print("checks:${snapshot.hasData}");
          print("stream err: ${snapshot.error}");
          if (snapshot.connectionState == ConnectionState.active) {
            print("Checking data.... ${snapshot.data!.docs}");
            List<Chat> messages = snapshot.data!.docs.map((documentSnapshot) {
              Map<String, dynamic> messageData = documentSnapshot.data();
              return Chat.fromMap(messageData);
            }).toList();
            // List<Chat> messages = snapshot.data!;
            if (messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sunny,
                      size: 50.h,
                      color: AppConst.kGreyLight,
                    ),
                    Text(
                      "Start chatting with your friend",
                      style: appstyle(
                        20.w,
                        AppConst.kLight,
                        FontWeight.w400,
                      ),
                    )
                  ],
                ),
              );
            }
            // print("Has Data, ${messages}");
            return ListView.builder(
              key: UniqueKey(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                print("stream2, ${messages[index].message}");
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Align(
                        alignment: (messages[index].messageType == "receive"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].messageType == "receive"
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(10.w),
                          child: Text(
                            messages[index].message,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: (messages[index].messageType == "receive"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 14.0.w,
                          right: 14.0.w,
                          bottom: 5.h,
                        ),
                        child: Text(
                          calculateDaysDifference(
                              messages[index].createdAt.toString()),
                          style: appstyle(
                              12.w, AppConst.kGreyLight, FontWeight.w200),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Container(); // Show loading indicator while data is being fetched
          }
        },
      ),
    );
  }

  Widget buildLastMessage(Chat message) {
    return Column(
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (message.messageType == "receive"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (message.messageType == "receive"
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: EdgeInsets.all(10.w),
              child: Text(
                message.message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ),
        Align(
          alignment: (message.messageType == "receive"
              ? Alignment.topLeft
              : Alignment.topRight),
          child: Padding(
            padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 5.h),
            child: Text(
              calculateDaysDifference(message.createdAt.toString()),
              style: appstyle(12.w, AppConst.kGreyLight, FontWeight.w200),
            ),
          ),
        ),
      ],
    );
  }

  Widget textFieldArea(String ownerUid) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              style: appstyle(12, AppConst.kLight, FontWeight.normal),
              hintStyle: appstyle(12, AppConst.kLight, FontWeight.normal),
              hintText: 'Write message...',
              controller: chat,
              obscureText: false,
              color: const Color.fromARGB(255, 121, 119, 119),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  ref.read(isSendEnabledProvider.notifier).state = false;
                } else {
                  ref.read(isSendEnabledProvider.notifier).state = true;
                }
              },
              prefixIcon: IconButton(
                onPressed: () async {},
                icon: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppConst.kLight),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.w),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppConst.kLight,
                  ),
                ),
              ),
              suffixIcon: Consumer(builder: (context, ref, child) {
                bool enableSend = ref.watch(isSendEnabledProvider);
                print(enableSend);
                return IconButton(
                  onPressed: enableSend
                      ? () async {
                          String message = chat.text;
                          chat.clear();
                          ref.read(isSendEnabledProvider.notifier).state =
                              false;
                          Chat newMessage = Chat(
                              friendUid: widget.friendUid,
                              messageType: 'sender',
                              createdAt: DateTime.now(),
                              message: message,
                              read: false);
                          ref
                              .read(chatNotifierProvider.notifier)
                              .updateChat(newMessage);

                          await StoreFirebase()
                              .storeChat(ownerUid, widget.friendUid, message);
                        }
                      : null,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppConst.kLight,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
