import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../forums/domain/forum_models.dart';
import '../providers/thread_providers.dart';
import '../domain/thread_models.dart';

class ThreadListScreen extends ConsumerWidget {
  const ThreadListScreen({required this.forumId, this.forum, super.key});

  final String forumId;
  final ForumSummary? forum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threads = ref.watch(threadPageProvider(ThreadPageRequest(threadId: forumId)));

    return Scaffold(
      appBar: AppBar(title: Text(forum?.title ?? 'Threads')),
      body: threads.when(
        data: (page) => ListView.builder(
          itemCount: page.posts.length,
          itemBuilder: (context, index) {
            final post = page.posts[index];
            return ListTile(
              title: Text(post.author),
              subtitle: Text(post.content),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
