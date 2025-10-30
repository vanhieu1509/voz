import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/forums/presentation/home_screen.dart';
import '../../features/forums/presentation/forum_list_screen.dart';
import '../../features/threads/presentation/thread_detail_screen.dart';
import '../../features/threads/presentation/thread_list_screen.dart';
import '../../features/threads/presentation/composer_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/notifications/presentation/notification_inbox_screen.dart';
import '../../features/threads/domain/thread_models.dart';
import '../../features/forums/domain/forum_models.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/webview/presentation/webview_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authGuard = ref.watch(authGuardProvider);

  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: '/home',
    refreshListenable: authGuard,
    redirect: (context, state) {
      final loggedIn = authGuard.isAuthenticated;
      final loggingIn = state.location == '/login';

      if (!loggedIn) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn && loggedIn) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'forums',
            builder: (context, state) => const ForumListScreen(),
          ),
          GoRoute(
            path: 'threads/:forumId',
            builder: (context, state) {
              final forum = state.extra as ForumSummary?;
              final forumId = state.pathParameters['forumId'] ?? '';
              return ThreadListScreen(forumId: forumId, forum: forum);
            },
          ),
          GoRoute(
            path: 'thread/:threadId',
            builder: (context, state) {
              final threadId = state.pathParameters['threadId'] ?? '';
              final thread = state.extra as ThreadSummary?;
              return ThreadDetailScreen(threadId: threadId, initialThread: thread);
            },
          ),
          GoRoute(
            path: 'composer',
            builder: (context, state) {
              final params = state.extra as ComposerParams?;
              return ComposerScreen(params: params);
            },
          ),
          GoRoute(
            path: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationInboxScreen(),
          ),
          GoRoute(
            path: 'webview',
            builder: (context, state) {
              final url = state.uri.queryParameters['url'] ?? '';
              return WebViewScreen(url: url);
            },
          ),
        ],
      ),
    ],
  );
});
