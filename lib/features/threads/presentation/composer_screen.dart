import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/thread_models.dart';
import '../providers/thread_providers.dart';

class ComposerScreen extends HookConsumerWidget {
  const ComposerScreen({this.params, super.key});

  final ComposerParams? params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: params?.quotePost?.content ?? '');
    final composeState = ref.watch(composeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reply')), 
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(hintText: 'Write your reply using BBCode'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: composeState.isLoading
                  ? null
                  : () => ref.read(composeProvider.notifier).submit(params?.threadId ?? '', controller.text),
              icon: composeState.isLoading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              label: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
