import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/thread_repository.dart';
import '../domain/thread_models.dart';

final threadPageProvider = FutureProvider.family<ThreadPage, ThreadPageRequest>((ref, request) async {
  return ref.watch(threadRepositoryProvider).getThread(request.threadId, request.page);
});

final composeProvider = StateNotifierProvider<ComposeNotifier, AsyncValue<void>>((ref) {
  return ComposeNotifier(ref.watch(threadRepositoryProvider));
});

class ComposeNotifier extends StateNotifier<AsyncValue<void>> {
  ComposeNotifier(this._repository) : super(const AsyncData<void>(null));

  final ThreadRepository _repository;

  Future<void> submit(String threadId, String bbcode) async {
    state = const AsyncLoading<void>();
    try {
      await _repository.postReply(threadId, bbcode);
      state = const AsyncData<void>(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

class ThreadPageRequest {
  ThreadPageRequest({required this.threadId, this.page = 1});

  final String threadId;
  final int page;
}
