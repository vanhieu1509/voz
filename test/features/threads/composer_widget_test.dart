import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:voz_forum_app/features/threads/domain/thread_models.dart';
import 'package:voz_forum_app/features/threads/presentation/composer_screen.dart';
import 'package:voz_forum_app/features/threads/providers/thread_providers.dart';
import 'package:voz_forum_app/features/threads/data/thread_repository.dart';

void main() {
  testWidgets('composer submits text', (tester) async {
    var submitted = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          composeProvider.overrideWith(() => _TestComposeNotifier(() => submitted = true)),
        ],
        child: const MaterialApp(
          home: ComposerScreen(params: ComposerParams(threadId: '1')),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Hi');
    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(submitted, isTrue);
  });
}

class _TestComposeNotifier extends ComposeNotifier {
  _TestComposeNotifier(this._onSubmit) : super(_FakeThreadRepository());

  final VoidCallback _onSubmit;

  @override
  Future<void> submit(String threadId, String bbcode) async {
    _onSubmit();
  }
}

class _FakeThreadRepository extends ThreadRepository {
  _FakeThreadRepository() : super((_) => throw UnimplementedError());

  @override
  Future<void> postReply(String threadId, String bbcode) async {}

  @override
  Future<ThreadPage> getThread(String threadId, int page) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> toggleWatch(String threadId, {required bool isWatching}) async {
    throw UnimplementedError();
  }
}
