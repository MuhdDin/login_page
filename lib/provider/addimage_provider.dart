import 'package:flutter_riverpod/flutter_riverpod.dart';

final addImageNotifierProvider =
    StateNotifierProvider<AddImageNotifier, bool>((ref) {
  return AddImageNotifier();
});

class AddImageNotifier extends StateNotifier<bool> {
  AddImageNotifier() : super(false);

  void triggerRebuild() {
    state = !state;
  }
}
