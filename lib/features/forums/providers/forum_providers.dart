import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/forum_repository.dart';
import '../domain/forum_models.dart';
import '../../threads/domain/thread_models.dart';

final categoriesProvider = FutureProvider<List<ForumCategory>>((ref) {
  return ref.watch(forumRepositoryProvider).listCategories();
});

final newThreadsProvider = FutureProvider<List<ThreadListItem>>((ref) async {
  final threads = await ref.watch(forumRepositoryProvider).listThreads('new', 1);
  return threads
      .map((forum) => ThreadListItem(summary: ThreadSummary(id: forum.id, title: forum.title, author: 'vozUser')))
      .toList();
});

final hotThreadsProvider = FutureProvider<List<ThreadListItem>>((ref) async {
  final threads = await ref.watch(forumRepositoryProvider).listThreads('hot', 1);
  return threads
      .map((forum) => ThreadListItem(summary: ThreadSummary(id: forum.id, title: forum.title, author: 'vozUser')))
      .toList();
});

final watchedThreadsProvider = FutureProvider<List<ThreadListItem>>((ref) async {
  final threads = await ref.watch(forumRepositoryProvider).listThreads('watched', 1);
  return threads
      .map((forum) => ThreadListItem(summary: ThreadSummary(id: forum.id, title: forum.title, author: 'vozUser')))
      .toList();
});

class ThreadListItem {
  ThreadListItem({required this.summary});

  final ThreadSummary summary;
}
