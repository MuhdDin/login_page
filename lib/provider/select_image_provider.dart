import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'select_image_provider.g.dart';

@riverpod
class ImageService extends _$ImageService {
  @override
  String build() {
    return "";
  }

  void fileUrl(String newState) {
    state = newState;
  }
}
