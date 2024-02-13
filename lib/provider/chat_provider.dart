import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_page/model/chat.dart';

final chatNotifierProvider = StateNotifierProvider<ChatNotifier, Chat>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<Chat> {
  ChatNotifier()
      : super(Chat(
            friendUid: '',
            messageType: '',
            createdAt: DateTime.now(),
            message: '',
            read: false));

  void updateChat(Chat newState) {
    state = newState;
  }
}
