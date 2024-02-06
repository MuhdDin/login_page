import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'username_provider.g.dart';

@riverpod
class UsernameState extends _$UsernameState {
  @override
  String build() {
    return "";
  }

  void setUsername(String newState) {
    state = newState;
  }
}
