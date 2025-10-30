import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
