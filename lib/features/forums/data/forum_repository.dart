import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../../../core/parsers/forum_parser.dart';
import '../../../core/parsers/forum_thread_list_parser.dart';
import '../domain/forum_models.dart';
import '../../threads/domain/thread_models.dart';

class ForumRepository {
  ForumRepository(this._ref);

  final Ref _ref;

  Future<List<ForumCategory>> listCategories() async {
    final dio = _ref.read(dioProvider);
    final parser = _ref.read(forumParserProvider);
    final response = await dio.get<String>(
      '/',
      options: Options(responseType: ResponseType.plain),
    );
    final html = response.data ?? '';
    return parser.parseCategories(html);
  }

  Future<ForumThreadListPage> listThreads(String categoryId, int page) async {
    if (!_looksLikeForumPath(categoryId)) {
      final threads = List.generate(10, (index) {
        final summary = ThreadSummary(
          id: '$categoryId-$page-$index',
          title: 'Thread $index',
          author: 'vozUser',
        );
        return ForumThreadListItem(
          summary: summary,
          url: '/t/${summary.id}/',
          replyCount: 0,
          viewCount: 0,
        );
      });

      return ForumThreadListPage(
        threads: threads,
        pagination: ThreadPagination(currentPage: page, totalPages: 1),
      );
    }

    final dio = _ref.read(dioProvider);
    final parser = _ref.read(forumThreadListParserProvider);
    final path = _resolveForumPath(categoryId, page);
    final response = await dio.get<String>(
      path,
      options: Options(responseType: ResponseType.plain),
    );
    final document = response.data ?? '';
    return parser.parse(document, page: page);
  }
}

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  ref.watch(dioProvider); // ensure dependency
  ref.watch(forumParserProvider);
  ref.watch(forumThreadListParserProvider);
  return ForumRepository(ref);
});

bool _looksLikeForumPath(String categoryId) {
  return categoryId.contains('/') || categoryId.contains('.');
}

String _resolveForumPath(String categoryId, int page) {
  var sanitized = categoryId.trim();
  if (sanitized.startsWith('/')) {
    sanitized = sanitized.substring(1);
  }
  if (!sanitized.startsWith('f/')) {
    sanitized = 'f/$sanitized';
  }
  if (!sanitized.endsWith('/')) {
    sanitized = '$sanitized/';
  }
  if (page > 1) {
    sanitized = '${sanitized}page-$page';
  }
  return sanitized;
}
