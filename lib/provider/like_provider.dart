import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_page/firebase/storage.dart';
import 'package:login_page/model/likes.dart';
import 'package:login_page/model/notification.dart';
import 'package:login_page/provider/notification_provider.dart';

final imageLikesProvider =
    StateNotifierProvider.family<ImageLikesNotifier, bool, String>(
  (ref, postId) => ImageLikesNotifier(postId),
);

final selectedImageLikesProvider = Provider.family<bool, String>((ref, postId) {
  // Select only the state without triggering likeImage or unlikeImage
  return ref.read(imageLikesProvider(postId).select((value) => value));
});

class ImageLikesNotifier extends StateNotifier<bool> {
  ImageLikesNotifier(this.postId) : super(false);

  final String postId;

  Future<void> setImageLiked(bool liked) async {
    state = liked;
  }

  Future<void> likeImage(String id, NotificationModel notification,
      String posterId, WidgetRef ref) async {
    await setImageLiked(true);

    await StoreFirebase().likeImage(
      LikeImage(
        createdAt: DateTime.now(),
        userId: id,
      ),
      postId,
    );
    if (id != posterId) {
      ref.read(rebuildNotificationProvider.notifier).setNotification();
      await StoreFirebase().createNotification(notification, posterId);
    }
  }

  Future<void> unlikeImage(String id) async {
    await setImageLiked(false);
    await StoreFirebase().unlikeImage(postId, id);
  }
}
