import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/parsers/thread_parser.dart';
import '../domain/thread_models.dart';

class ThreadRepository {
  ThreadRepository(this._reader);

  final Reader _reader;

  Future<ThreadPage> getThread(String threadId, int page) async {
    final dio = _reader(dioProvider);
    final parser = _reader(threadParserProvider);

    final path = _resolveThreadPath(threadId, page);
    final response = await dio.get<String>(
      path,
      options: Options(responseType: ResponseType.plain),
    );

    final document = response.data ?? '';
    return parser.parseThread(
      document,
      page: page,
      threadIdFallback: threadId,
    );
  }

  Future<void> postReply(String threadId, String bbcode) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> toggleWatch(String threadId, {required bool isWatching}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return !isWatching;
  }
}

final threadRepositoryProvider = Provider<ThreadRepository>((ref) {
  ref.watch(dioProvider);
  return ThreadRepository(ref.read);
});

String _resolveThreadPath(String threadId, int page) {
  var sanitized = threadId.trim();
  if (sanitized.startsWith('/')) {
    sanitized = sanitized.substring(1);
  }
  if (sanitized.endsWith('/')) {
    sanitized = sanitized.substring(0, sanitized.length - 1);
  }

  if (!sanitized.startsWith('t/')) {
    sanitized = 't/$sanitized';
  }

  if (page > 1) {
    return '$sanitized/page-$page';
  }
  return sanitized;
}
