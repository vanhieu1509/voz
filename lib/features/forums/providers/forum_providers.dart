import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/forum_repository.dart';
import '../domain/forum_models.dart';
import '../../threads/domain/thread_models.dart';

final categoriesProvider = FutureProvider<List<ForumCategory>>((ref) {
  return ref.watch(forumRepositoryProvider).listCategories();
});

final newThreadsProvider = FutureProvider<List<ForumThreadListItem>>((ref) async {
  final page = await ref.watch(forumRepositoryProvider).listThreads('new', 1);
  return page.threads;
});

final hotThreadsProvider = FutureProvider<List<ForumThreadListItem>>((ref) async {
  final page = await ref.watch(forumRepositoryProvider).listThreads('hot', 1);
  return page.threads;
});

final watchedThreadsProvider = FutureProvider<List<ForumThreadListItem>>((ref) async {
  final page = await ref.watch(forumRepositoryProvider).listThreads('watched', 1);
  return page.threads;
});
