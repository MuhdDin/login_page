import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_page/animator/widget_animator_slidelr.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/auth.dart';
import 'package:login_page/firebase/check_login.dart';
import 'package:login_page/provider/error_message_provider.dart';
import 'package:login_page/provider/icon/icon_provider.dart';
import 'package:login_page/provider/title_provider.dart';
import 'package:login_page/sign_in/page/sign_in.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/custom_button.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:video_player/video_player.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late VideoPlayerController? videoController;
  String title = "MY PROJECT";
  bool obscureText = false;
  bool isAnimationComplete = false;
  String password2 = '';
  String errorPassword = '';

  @override
  void initState() {
    videoController = VideoPlayerController.asset('assets/image/test_video.mp4')
      ..initialize().then((_) {
        videoController!.play();
        videoController!.setLooping(true);
        setState(
          () {},
        );
      }).catchError((e) {
        print("unhandled error: $e");
      });
    super.initState();
  }

  Future<void> _disposeController() async {
    if (videoController != null) {
      await videoController!.dispose();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isComplete = ref.watch(titleProviderProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoController!.value.size.width,
                  height: videoController!.value.size.height,
                  child: Stack(children: [
                    VideoPlayer(videoController!),
                    Opacity(
                      opacity: 0.6,
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  ]),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(isComplete),
                  const HeightSpacer(hieght: 5),
                  Text(
                    ref.watch(errorMsgStateProvider),
                    style: appstyle(12, Colors.red, FontWeight.w500),
                  ),
                  const HeightSpacer(hieght: 20),
                  _buildTextField(
                      'Enter email', emailController, Icons.email, false),
                  const HeightSpacer(hieght: 20),
                  _buildPasswordTextField(),
                  const HeightSpacer(hieght: 10),
                  _buildSignInRow(context),
                  const HeightSpacer(hieght: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isComplete) {
    // return  AnimatedTextKit(
    //         animatedTexts: [
    //           WavyAnimatedText(title,
    //               textStyle: appstyle(
    //                 30,
    //                 AppConst.kLight,
    //                 FontWeight.w700,
    //               ),
    //               speed: const Duration(milliseconds: 450)),
    //         ],
    //         repeatForever: true,
    //         pause: const Duration(milliseconds: 2000),
    //       );
    return TextAnimator(
      title,
      incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut),
      onIncomingAnimationComplete: (p0) async {
        await Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(titleProviderProvider.notifier).setStart(true);
        });
      },
      initialDelay: const Duration(milliseconds: 1000),
      style: appstyle(30, AppConst.kLight, FontWeight.w700),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      IconData icon, bool isPassword) {
    return CustomTextField(
      hintText: hintText,
      controller: controller,
      prefixIcon: Icon(icon),
      obscureText: isPassword,
      color: AppConst.kLight,
    );
  }

  // Widget _buildAnimatedTextField(
  //     String hintText, TextEditingController controller, IconData icon) {
  //   return AnimatorWidgetSlideLR(
  //     animation: 0,
  //     time1: 1000,
  //     time2: 1500,
  //     curve: Curves.easeInOut,
  //     scale: 0.5,
  //     complete: (key) {
  //       isAnimationComplete = true;
  //     },
  //     child: _buildTextField(hintText, controller, icon, false),
  //   );
  // }

  Widget _buildPasswordTextField() {
    return CustomTextField(
      hintText: 'password',
      controller: passwordController,
      maxLines: 1,
      color: AppConst.kLight,
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: GestureDetector(
        onTap: () {
          ref.read(iconStateProvider.notifier).newState(obscureText);
          obscureText = !obscureText;
        },
        child: ref.watch(iconStateProvider)
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off),
      ),
      validator: (val) => val!.length < 6 ? 'Password too short' : null,
      onSaved: (val) => password2 = val!,
      obscureText: !obscureText,
    );
  }

  // Widget _buildAnimatedPasswordTextField() {
  //   return AnimatorWidgetSlideLR(
  //     animation: 0,
  //     time1: 1000,
  //     time2: 1500,
  //     curve: Curves.easeInOut,
  //     scale: 0.5,
  //     complete: (key) {
  //       isAnimationComplete = true;
  //     },
  //     child: _buildPasswordTextField(),
  //   );
  // }

  Widget _buildSignInRow(BuildContext context) {
    return AnimatorWidgetSlideLR(
      animation: 0,
      time1: 1000,
      time2: 1500,
      curve: Curves.easeInOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account? ",
              style: appstyle(10, AppConst.kLight, FontWeight.normal)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ),
              );
            },
            child: const Text(
              "Sign in here",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppConst.kLight),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatorWidgetSlideLR(
      animation: 1,
      time1: 1000,
      time2: 1500,
      curve: Curves.easeInOut,
      scale: 0.5,
      child: CustomButton(
        height: 40.h,
        width: 0.5,
        text: 'Submit',
        borderColor: AppConst.kLight,
        style: appstyle(16, Colors.white, FontWeight.w500),
        onTap: () async {
          var receive = await Authentication()
              .signIn(emailController.text, passwordController.text);
          if (receive[0] == true) {
            if (context.mounted) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthWrapper()));
            }
          } else {
            ref.read(errorMsgStateProvider.notifier).setError(receive[1]);
          }
        },
      ),
    );
  }
}
