import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'error_message_provider.g.dart';

@riverpod
class ErrorMsgState extends _$ErrorMsgState {
  @override
  String build() {
    return "";
  }

  void setError(String newState) {
    state = newState;
  }
}
