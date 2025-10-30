import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:voz_forum_app/features/threads/domain/thread_models.dart';
import 'package:voz_forum_app/features/threads/presentation/thread_detail_screen.dart';
import 'package:voz_forum_app/features/threads/providers/thread_providers.dart';

void main() {
  testWidgets('thread detail renders provided posts', (tester) async {
    final threadPage = ThreadPage(
      thread: const ThreadSummary(id: '1', title: 'Test Thread', author: 'Tester'),
      posts: [
        PostModel(id: 'p1', author: 'Tester', content: 'Hello', postedAt: DateTime(2024, 1, 1)),
      ],
      pagination: const ThreadPagination(
        currentPage: 1,
        totalPages: 1,
        nextPageUrl: null,
        previousPageUrl: null,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          threadPageProvider.overrideWith((ref, request) async => threadPage),
        ],
        child: const MaterialApp(
          home: ThreadDetailScreen(threadId: '1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Page 1 of 1'), findsOneWidget);
  });
}
