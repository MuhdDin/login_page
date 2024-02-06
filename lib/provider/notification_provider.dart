import 'package:flutter_riverpod/flutter_riverpod.dart';

final rebuildNotificationProvider =
    StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(false);

  void setNotification() {
    state = !state;
  }
}
