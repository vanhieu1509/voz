import 'package:flutter_test/flutter_test.dart';
import 'package:voz_forum_app/features/threads/data/thread_repository.dart';
import 'package:voz_forum_app/features/threads/domain/thread_models.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('postReply completes successfully', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    await repository.postReply('1', 'Hello');
  });

  test('toggleWatch flips state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    final result = await repository.toggleWatch('1', isWatching: false);
    expect(result, isTrue);
  });

  test('getThread returns posts', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    final page = await repository.getThread('1', 1);
    expect(page, isA<ThreadPage>());
    expect(page.posts, isNotEmpty);
  });
}
