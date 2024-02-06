import 'package:login_page/model/comments.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment_provider.g.dart';

@riverpod
class CommentService extends _$CommentService {
  @override
  UsersComments build() {
    return UsersComments(createdAt: DateTime.now(), comment: '', userId: '');
  }

  void newComment(UsersComments newState) {
    state = newState;
  }
}
