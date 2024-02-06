import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_page/constant/constants.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/image_picker/image_picker.dart';
import 'package:login_page/location/map_location.dart';
import 'package:login_page/model/posts.dart';
import 'package:login_page/model/user.dart';
import 'package:login_page/provider/click_provider.dart';
import 'package:login_page/provider/select_image_provider.dart';
import 'package:login_page/widget/appstyle.dart';
import 'package:login_page/widget/bottom_navigation.dart';
import 'package:login_page/widget/custom_button.dart';
import 'package:login_page/widget/custom_text.dart';
import 'package:login_page/widget/height_spacer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:uuid/uuid.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage(this.username, {Key? key}) : super(key: key);

  final String username;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  String? _currentAddress;
  Position? _currentPosition;
  late List? fileName = [];
  TextEditingController title = TextEditingController();

  Future<void> _getCurrentPosition() async {
    final hasPermission = await GetAddress().handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then(
      (List<Placemark> placemarks) {
        Placemark place = placemarks[0];

        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}";
        ref.read(tapNotifierProvider.notifier).triggerRebuild();
      },
    ).catchError(
      (e) {
        debugPrint(e);
      },
    );
  }

  Future<void> postImageToFirebase(String uid, String user) async {
    const Uuid uuidName = Uuid();
    final String id = uuidName.v4();
    print('done $fileName');
    String donwloadUrl = await StoreFirebase().dataStorage(fileName![1], uid);
    print('done1');

    ImagePost imagePost = ImagePost(
      uid: uid,
      userName: user,
      id: id,
      caption: title.text,
      address: _currentAddress!,
      date: DateTime.now(),
      imageUrl: donwloadUrl,
    );
    print('done2');

    await StoreFirebase().storePhotoDatabase(imagePost);
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller =
        ref.watch(persistentTabControllerProvider);
    String image = ref.watch(imageServiceProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20.0.w, bottom: 15.h),
                child: FutureBuilder(
                    future:
                        StoreFirebase().fetchUserDatabyName(widget.username),
                    builder: (context, snapshot) {
                      UserInfoOri? data = snapshot.data;
                      return Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () async {
                            print("post");
                            await postImageToFirebase(
                                data!.uid!, data.userName);
                            if (mounted) {
                              controller.jumpToTab(0);
                            }
                          },
                          child: const Text(
                            'Post',
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 20,
                                color: Color.fromARGB(255, 52, 189, 248),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    }),
              ),
              GestureDetector(
                onTap: () async {
                  fileName = await SelectImage().selectImage(ref);
                },
                child: Container(
                  decoration: const BoxDecoration(color: AppConst.kBkDark),
                  width: AppConst.kWidth * 0.9,
                  height: AppConst.kHeight * 0.5,
                  child: image.isNotEmpty
                      ? Center(
                          child: ClipRRect(
                            child: Image.memory(
                              base64Decode(image),
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        )
                      : DottedBorder(
                          color: Colors.white,
                          strokeWidth: 1,
                          child: Center(
                              child: Icon(
                            Icons.add,
                            color: AppConst.kLight,
                            size: 40.h,
                          )),
                        ),
                ),
              ),
              const HeightSpacer(hieght: 15),
              CustomTextField(
                hintText: 'Add caption',
                style: appstyle(15, AppConst.kGreyLight, FontWeight.normal),
                controller: title,
                obscureText: false,
                color: AppConst.kGreyDk,
                hintStyle: const TextStyle(
                    color: AppConst.kGreyLight,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              const HeightSpacer(hieght: 15),
              Container(
                width: AppConst.kWidth * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppConst.kRadius),
                  ),
                ),
                child: Consumer(builder: (context, ref, child) {
                  ref.watch(tapNotifierProvider);
                  return Text(
                    _currentAddress ?? '',
                    style: appstyle(15, AppConst.kLight, FontWeight.bold),
                  );
                }),
              ),
              const HeightSpacer(hieght: 15),
              CustomButton(
                height: 40.h,
                onTap: () => _getCurrentPosition(),
                width: 0.4,
                text: 'Add Location',
                borderColor: AppConst.kLight,
                style: appstyle(14, const Color.fromARGB(255, 52, 189, 248),
                    FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
