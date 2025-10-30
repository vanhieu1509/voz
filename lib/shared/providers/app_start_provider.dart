import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/notifications/providers/notification_providers.dart';

final appStartProvider = FutureProvider<void>((ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  final session = await authRepo.getCurrentSession();
  if (session != null) {
    ref.read(authStateProvider.notifier).state = AuthState.authenticated(session);
  }
  await ref.read(notificationServiceProvider).initialize();
});
