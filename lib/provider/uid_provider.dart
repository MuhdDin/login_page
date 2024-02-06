import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'uid_provider.g.dart';

@riverpod
class UidState extends _$UidState {
  @override
  String build() {
    return "";
  }

  void setUid(String newState) {
    state = newState;
  }
}
