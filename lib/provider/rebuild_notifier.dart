import 'package:flutter_riverpod/flutter_riverpod.dart';

final rebuildNotifierProvider =
    StateNotifierProvider<RebuildNotifier, bool>((ref) {
  return RebuildNotifier();
});

class RebuildNotifier extends StateNotifier<bool> {
  RebuildNotifier() : super(false);

  void triggerRebuild() {
    state = !state;
  }
}
