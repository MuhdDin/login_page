import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'icon_provider.g.dart';

@riverpod
class IconState extends _$IconState {
  @override
  bool build() {
    return false;
  }

  void newState(bool newState) {
    state = !newState;
  }
}
