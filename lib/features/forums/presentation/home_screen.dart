import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/localization/app_localizations.dart';
import '../providers/forum_providers.dart';
import '../../threads/providers/thread_providers.dart';
import '../../threads/domain/thread_models.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    final localization = AppLocalizations.of(context);

    final newThreads = ref.watch(newThreadsProvider);
    final hotThreads = ref.watch(hotThreadsProvider);
    final watchedThreads = ref.watch(watchedThreadsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('home')),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: localization.translate('new')),
            Tab(text: localization.translate('hot')),
            Tab(text: localization.translate('watched')),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/home/search'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/home/settings'),
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ThreadListView(state: newThreads),
          ThreadListView(state: hotThreads),
          ThreadListView(state: watchedThreads),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text(localization.translate('forums'))),
            ListTile(
              title: Text(localization.translate('forums')),
              onTap: () => context.push('/home/forums'),
            ),
            ListTile(
              title: Text(localization.translate('notifications')),
              onTap: () => context.push('/home/notifications'),
            ),
          ],
        ),
      ),
    );
  }
}

class ThreadListView extends StatelessWidget {
  const ThreadListView({required this.state, super.key});

  final AsyncValue<List<ForumThreadListItem>> state;

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (threads) {
        if (threads.isEmpty) {
          return const Center(child: Text('No threads available yet.'));
        }
        return ListView.separated(
          itemCount: threads.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = threads[index];
            final theme = Theme.of(context);
            final metadata = <String>[];
            if (item.summary.author.isNotEmpty) {
              metadata.add(item.summary.author);
            }
            if (item.replyCount != null) {
              metadata.add('${item.replyCount} replies');
            }
            if (item.viewCount != null) {
              metadata.add('${item.viewCount} views');
            }
            return ListTile(
              title: Text(item.summary.title),
              subtitle: metadata.isEmpty
                  ? null
                  : Text(
                      metadata.join(' • '),
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
