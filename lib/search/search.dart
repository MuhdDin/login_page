import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/search_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/search/search_post.dart';
import 'package:login_page/user/user_page.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:shimmer/shimmer.dart';

class SearchUser extends ConsumerStatefulWidget {
  const SearchUser({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchUserState();
}

class _SearchUserState extends ConsumerState<SearchUser> {
  TextEditingController search = TextEditingController();
  List<UserInfoOri> accounts = [];
  bool isTyping = false;
  @override
  Widget build(BuildContext context) {
    ref.watch(searchNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              searchFilter(),
              isTyping ? searchResult() : gridImageView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchFilter() {
    return CustomTextField(
        controller: search,
        onChanged: (value) async {
          accounts = await StoreFirebase().filterUserAccount(value);
          ref.read(searchNotifierProvider.notifier).triggerRebuild();
          if (value.isNotEmpty) {
            isTyping = true;
          } else {
            isTyping = false;
          }
          print("isTyping: $isTyping");
          print('hi, ${accounts.length}');
        },
        suffixIcon: const Icon(Icons.search),
        hintText: 'search name',
        obscureText: false,
        color: AppConst.kGreyLight);
  }

  Widget gridImageView() {
    String ownerName = ref.watch(usernameStateProvider);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(top: 8.0.h),
        child: SizedBox(
          height: AppConst.kHeight * 0.77,
          child: FutureBuilder(
            future: StoreFirebase().fetchPostData(),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      SearchPost(username: ownerName)),
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
        ),
      ),
    );
  }

  Widget searchResult() {
    String ownerName = ref.watch(usernameStateProvider);
    print('result');
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        // ref.watch(searchNotifierProvider);
        return SizedBox(
          width: AppConst.kWidth * 0.9,
          child: ListView(
            children: ListTile.divideTiles(
              color: const Color.fromARGB(255, 94, 94, 94),
              context: context,
              tiles: accounts.map((UserInfoOri account) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0.h),
                  child: GestureDetector(
                    onTap: () {
                      int role;
                      if (account.userName == ownerName) {
                        role = 0;
                      } else {
                        role = 1;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserPage(
                              userName: account.userName,
                              role: role,
                              userId: account.uid!),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(account.profilePicture!),
                      ),
                      title: Text(
                        account.userName,
                        style: appstyle(15, AppConst.kLight, FontWeight.w400),
                      ),
                    ),
                  ),
                );
              }),
            ).toList(),
          ),
        );
      }),
    );
  }
}
