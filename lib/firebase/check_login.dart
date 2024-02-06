import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/login_page/pages/login.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/uid_provider.dart';
import 'package:login_page/provider/username_provider.dart';
import 'package:login_page/widget/bottom_navigation.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print(user.uid);
      return FutureBuilder(
        future: StoreFirebase().fetchUserDatabyUid(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Delay the modification using Future
            UserInfoOri? data = snapshot.data;
            Future(() {
              print('initttt: ${user.uid}');
              ref.read(uidStateProvider.notifier).setUid(user.uid);
              ref.watch(uidStateProvider);
              ref
                  .read(usernameStateProvider.notifier)
                  .setUsername(data!.userName);
            });

            return const BottomNav();
          } else {
            return const Scaffold();
          }
        },
      );
    } else {
      return const LoginPage();
    }
  }
}
