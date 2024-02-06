import 'package:flutter_riverpod/flutter_riverpod.dart';

final tapNotifierProvider = StateNotifierProvider<TapNotifier, bool>((ref) {
  return TapNotifier();
});

class TapNotifier extends StateNotifier<bool> {
  TapNotifier() : super(false);

  void triggerRebuild() {
    state = !state;
  }
}
