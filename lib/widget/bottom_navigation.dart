import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/add/add_page.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/main_page/homepage.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/notification/notification_path.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/search/search.dart';
import 'package:login_page/user/user_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shimmer/shimmer.dart';

final persistentTabControllerProvider =
    Provider((ref) => PersistentTabController(initialIndex: 0));

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String user = ref.watch(usernameStateProvider);
    String id = ref.watch(uidStateProvider);
    print('usertest: $user');
    // PersistentTabController controller;
    // controller = PersistentTabController(initialIndex: 0);

    List<Widget> buildScreens() {
      return [
        const HomePage(),
        const SearchUser(),
        AddPage(user),
        const NotificationPage(),
        UserPage(
          userName: user,
          role: 0,
          userId: id,
        )
      ];
    }

    List<PersistentBottomNavBarItem> navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(
            Icons.home,
            size: 30.w,
          ),
          activeColorPrimary: AppConst.kLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(
            Icons.search,
            size: 30.w,
          ),
          activeColorPrimary: AppConst.kLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(
            Icons.add,
            size: 30.w,
          ),
          activeColorPrimary: AppConst.kLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(
            Icons.notifications_none,
            size: 30.w,
          ),
          activeColorPrimary: AppConst.kLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: FutureBuilder(
              future: StoreFirebase().fetchUserDatabyName(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  UserInfoOri? data = snapshot.data;
                  return CircleAvatar(
                    radius: 15.w,
                    backgroundImage: data!.profilePicture!.isNotEmpty
                        ? NetworkImage(data.profilePicture!)
                        : const AssetImage('assets/image/userIcon.png')
                            as ImageProvider,
                  );
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: const CircleAvatar(),
                  );
                }
              }),
          activeColorPrimary: AppConst.kLight,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: ref.read(persistentTabControllerProvider),
      screens: buildScreens(),
      items: navBarsItems(),
      confineInSafeArea: true,
      backgroundColor:
          const Color.fromARGB(255, 0, 0, 0), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10.w), right: Radius.circular(10.w)),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style13,
    );
  }
}
