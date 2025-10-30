import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: state.themeMode,
            decoration: const InputDecoration(labelText: 'Theme'),
            items: const [
              DropdownMenuItem(value: 'system', child: Text('System')),
              DropdownMenuItem(value: 'light', child: Text('Light')),
              DropdownMenuItem(value: 'dark', child: Text('Dark')),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsControllerProvider.notifier).updateThemeMode(value);
              }
            },
          ),
          const SizedBox(height: 16),
          Slider(
            value: state.fontScale,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: 'Font scale ${state.fontScale.toStringAsFixed(1)}',
            onChanged: (value) => ref.read(settingsControllerProvider.notifier).updateFontScale(value),
          ),
          SwitchListTile(
            value: state.autoLoadImages,
            title: const Text('Auto load images'),
            onChanged: (value) => ref.read(settingsControllerProvider.notifier).updateAutoLoadImages(value),
          ),
        ],
      ),
    );
  }
}
