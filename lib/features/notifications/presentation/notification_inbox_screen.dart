import 'package:flutter/material.dart';

class NotificationInboxScreen extends StatelessWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: const [
          ListTile(title: Text('Welcome to voz app'), subtitle: Text('You will receive updates here.')),
        ],
      ),
    );
  }
}
