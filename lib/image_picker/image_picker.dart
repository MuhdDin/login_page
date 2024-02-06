import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_page/provider/select_image_provider.dart';

class SelectImage {
  File? image;
  final ImagePicker picker = ImagePicker();

  Future<List<dynamic>> selectImage(WidgetRef ref) async {
    try {
      debugPrint("working selectImage");
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return [];
      final imageTemp = File(image.path);
      List<int> fileBytes = await imageTemp.readAsBytes();
      Uint8List uint8list = Uint8List.fromList(fileBytes);
      String dataUrl = base64Encode(uint8list);
      ref.read(imageServiceProvider.notifier).fileUrl(dataUrl);
      return [dataUrl, uint8list];
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
      return [];
    }
  }
}
