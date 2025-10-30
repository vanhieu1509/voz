import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService()
      : _messaging = FirebaseMessaging.instance,
        _localNotifications = FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initializationSettings);
  }

  Future<void> subscribeToThread(String threadId) async {
    await _messaging.subscribeToTopic('thread_$threadId');
  }

  Future<void> unsubscribeFromThread(String threadId) async {
    await _messaging.unsubscribeFromTopic('thread_$threadId');
  }
}
