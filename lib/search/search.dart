import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/search_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/user/user_page.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_text.dart';

class SearchUser extends ConsumerStatefulWidget {
  const SearchUser({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchUserState();
}

class _SearchUserState extends ConsumerState<SearchUser> {
  TextEditingController search = TextEditingController();
  List<UserInfoOri> accounts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              searchFilter(),
              searchResult(),
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
          print('hi, ${accounts.length}');
        },
        suffixIcon: const Icon(Icons.search),
        hintText: 'search name',
        obscureText: false,
        color: AppConst.kGreyLight);
  }

  Widget searchResult() {
    String ownerName = ref.watch(usernameStateProvider);
    print('result');
    return Expanded(
      child: Consumer(builder: (context, ref, child) {
        ref.watch(searchNotifierProvider);
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
