import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:voz_forum_app/core/parsers/thread_parser.dart';
import 'package:voz_forum_app/features/threads/data/thread_repository.dart';
import 'package:voz_forum_app/features/threads/domain/thread_models.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  test('postReply completes successfully', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    await repository.postReply('1', 'Hello');
  });

  test('toggleWatch flips state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    final result = await repository.toggleWatch('1', isWatching: false);
    expect(result, isTrue);
  });

  test('getThread returns posts', () async {
    final mockDio = _MockDio();
    final mockParser = _MockThreadParser();
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(mockDio),
        threadParserProvider.overrideWithValue(mockParser),
      ],
    );
    addTearDown(container.dispose);
    final repository = container.read(threadRepositoryProvider);

    when(() => mockDio.get<String>(any(), options: any(named: 'options')))
        .thenAnswer(
      (_) async => Response<String>(
        data: '<html></html>',
        requestOptions: RequestOptions(path: '/t/test-thread'),
      ),
    );

    final parsedPage = ThreadPage(
      thread: const ThreadSummary(
        id: 'test-thread',
        title: 'Thread title',
        author: 'User 0',
      ),
      posts: [
        PostModel(
          id: '1',
          author: 'User 0',
          content: 'Content',
          postedAt: DateTime(2024),
        ),
      ],
      pagination: const ThreadPagination(
        currentPage: 1,
        totalPages: 3,
        nextPageUrl: '/t/test-thread/page-2',
        previousPageUrl: null,
      ),
    );

    when(
      () => mockParser.parseThread(
        '<html></html>',
        page: 1,
        threadIdFallback: 'test-thread',
      ),
    ).thenReturn(parsedPage);

    final page = await repository.getThread('test-thread', 1);
    expect(page, parsedPage);

    verify(() => mockDio.get<String>(
          't/test-thread',
          options: any(named: 'options'),
        )).called(1);
    verify(
      () => mockParser.parseThread(
        '<html></html>',
        page: 1,
        threadIdFallback: 'test-thread',
      ),
    ).called(1);
  });
}

class _MockDio extends Mock implements Dio {}

class _MockThreadParser extends Mock implements ThreadParser {}
