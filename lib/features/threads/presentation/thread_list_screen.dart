import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../forums/domain/forum_models.dart';
import '../providers/thread_providers.dart';

class ThreadListScreen extends HookConsumerWidget {
  const ThreadListScreen({required this.forumId, this.forum, super.key});

  final String forumId;
  final ForumSummary? forum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageState = useState(1);
    final pageAsync = ref.watch(
      forumThreadListProvider(
        ForumThreadListRequest(forumId: forumId, page: pageState.value),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(forum?.title ?? 'Threads')),
      body: pageAsync.when(
        data: (page) {
          final threads = page.threads;
          final pagination = page.pagination;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Page ${pagination.currentPage} of ${pagination.totalPages}'),
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
                child: threads.isEmpty
                    ? const Center(child: Text('No threads found.'))
                    : ListView.separated(
                        itemCount: threads.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = threads[index];
                          final theme = Theme.of(context);
                          final meta = <String>[];
                          if (item.summary.author.isNotEmpty) {
                            meta.add(item.summary.author);
                          }
                          if (item.replyCount != null) {
                            meta.add('${item.replyCount} replies');
                          }
                          if (item.viewCount != null) {
                            meta.add('${item.viewCount} views');
                          }

                          return ListTile(
                            leading: item.isSticky
                                ? const Icon(Icons.push_pin, size: 20)
                                : null,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.prefixes.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Wrap(
                                      spacing: 6,
                                      children: item.prefixes
                                          .map((prefix) => Chip(
                                                label: Text(prefix),
                                                visualDensity: VisualDensity.compact,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize.shrinkWrap,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                Text(item.summary.title),
                              ],
                            ),
                            subtitle: meta.isEmpty
                                ? null
                                : Text(
                                    meta.join(' • '),
                                    style: theme.textTheme.bodySmall,
                                  ),
                            trailing: item.isUnread
                                ? Icon(Icons.fiber_new, color: theme.colorScheme.primary)
                                : null,
                            onTap: () => GoRouter.of(context).push(
                              '/home/thread/${item.summary.id}',
                              extra: item.summary,
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
    );
  }
}
