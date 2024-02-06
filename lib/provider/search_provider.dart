import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, bool>((ref) {
  return SearchNotifier();
});

class SearchNotifier extends StateNotifier<bool> {
  SearchNotifier() : super(false);

  void triggerRebuild() {
    state = !state;
  }
}
