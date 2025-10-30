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
    final pageState = useState(1);
    final pageAsync = ref.watch(
      threadPageProvider(
        ThreadPageRequest(threadId: threadId, page: pageState.value),
      ),
    );
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
        data: (page) {
          final pagination = page.pagination;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Page ${pagination.currentPage} of ${pagination.totalPages}',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: pagination.hasPreviousPage
                          ? () {
                              final targetPage = pagination.currentPage > 1
                                  ? pagination.currentPage - 1
                                  : 1;
                              if (targetPage != pageState.value) {
                                pageState.value = targetPage;
                              }
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: pagination.hasNextPage
                          ? () {
                              final targetPage = pagination.currentPage + 1;
                              if (targetPage != pageState.value) {
                                pageState.value = targetPage;
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.author,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      if (post.authorTitle != null)
                                        Text(
                                          post.authorTitle!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                                if (post.position != null)
                                  Text(
                                    '#${post.position}',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(post.content),
                            const SizedBox(height: 8),
                            if (post.permalink != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: SelectableText(
                                  post.permalink!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                post.postedAt.toLocal().toIso8601String(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
