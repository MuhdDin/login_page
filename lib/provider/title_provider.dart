import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'title_provider.g.dart';

@riverpod
class TitleProvider extends _$TitleProvider {
  @override
  bool build() {
    return false;
  }

  void setStart(bool newState) {
    state = newState;
  }
}
