import 'package:flutter_riverpod/flutter_riverpod.dart';

final readMessageProvider =
    StateNotifierProvider<ReadMessageNotifier, bool>((ref) {
  return ReadMessageNotifier();
});

class ReadMessageNotifier extends StateNotifier<bool> {
  ReadMessageNotifier() : super(false);

  void triggerRebuild() {
    state = !state;
  }
}
