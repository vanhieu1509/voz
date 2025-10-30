import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/thread_models.dart';

class ThreadRepository {
  ThreadRepository(this._reader);

  final Reader _reader;

  Future<ThreadPage> getThread(String threadId, int page) async {
    final posts = List.generate(
      10,
      (index) => PostModel(
        id: '$threadId-$page-$index',
        author: 'User $index',
        content: 'Post content $index',
        postedAt: DateTime.now().subtract(Duration(minutes: index * 5)),
      ),
    );
    return ThreadPage(
      thread: ThreadSummary(id: threadId, title: 'Thread $threadId', author: 'User 0'),
      posts: posts,
      page: page,
    );
  }

  Future<void> postReply(String threadId, String bbcode) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> toggleWatch(String threadId, {required bool isWatching}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return !isWatching;
  }
}

final threadRepositoryProvider = Provider<ThreadRepository>((ref) {
  ref.watch(dioProvider);
  return ThreadRepository(ref.read);
});
