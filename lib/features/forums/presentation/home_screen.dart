import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/localization/app_localizations.dart';
import '../providers/forum_providers.dart';
import '../../threads/providers/thread_providers.dart';

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

  final AsyncValue<List<ThreadListItem>> state;

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (threads) => ListView.builder(
        itemCount: threads.length,
        itemBuilder: (context, index) {
          final item = threads[index];
          return ListTile(
            title: Text(item.summary.title),
            subtitle: Text(item.summary.author),
            onTap: () => GoRouter.of(context).push('/home/thread/${item.summary.id}', extra: item.summary),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
