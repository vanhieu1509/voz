import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/thread_providers.dart';
import '../domain/thread_models.dart';
import '../../notifications/providers/notification_providers.dart';
import '../data/thread_repository.dart';

class ThreadDetailScreen extends HookConsumerWidget {
  const ThreadDetailScreen({required this.threadId, this.initialThread, super.key});

  final String threadId;
  final ThreadSummary? initialThread;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageAsync = ref.watch(threadPageProvider(ThreadPageRequest(threadId: threadId)));
    final isWatching = useState(false);

    return Scaffold(
      appBar: AppBar(
        title: Text(initialThread?.title ?? 'Thread'),
        actions: [
          IconButton(
            icon: Icon(isWatching.value ? Icons.notifications_active : Icons.notifications_off),
            onPressed: () async {
              final result = await ref.read(threadRepositoryProvider).toggleWatch(threadId, isWatching: isWatching.value);
              isWatching.value = result;
              if (result) {
                await ref.read(notificationServiceProvider).subscribeToThread(threadId);
              } else {
                await ref.read(notificationServiceProvider).unsubscribeFromThread(threadId);
              }
            },
          ),
        ],
      ),
      body: pageAsync.when(
        data: (page) => ListView.builder(
          itemCount: page.posts.length,
          itemBuilder: (context, index) {
            final post = page.posts[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.author, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(post.content),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(post.postedAt.toIso8601String(), style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/home/composer', extra: ComposerParams(threadId: threadId));
        },
        child: const Icon(Icons.reply),
      ),
    );
  }
}
