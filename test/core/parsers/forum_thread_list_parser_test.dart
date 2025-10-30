import 'dart:io';

import 'package:test/test.dart';

import 'package:voz_forum_app/core/parsers/forum_thread_list_parser.dart';

void main() {
  group('ForumThreadListParser', () {
    test('parses thread listings with pagination metadata', () {
      final parser = ForumThreadListParser();
      final document = File('test/fixtures/forum_thread_list.html').readAsStringSync();

      final result = parser.parse(document, page: 1);

      expect(result.pagination.currentPage, 1);
      expect(result.pagination.totalPages, 7);
      expect(result.pagination.nextPageUrl, '/f/tu-van-cau-hinh.70/page-2');
      expect(result.pagination.previousPageUrl, isNull);

      expect(result.threads, hasLength(2));

      final sticky = result.threads.first;
      expect(sticky.summary.id, 'sticky-thread.952');
      expect(sticky.summary.title.contains('Tiêu đề bắt buộc'), isTrue);
      expect(sticky.isSticky, isTrue);
      expect(sticky.isLocked, isTrue);
      expect(sticky.replyCount, 9);
      expect(sticky.viewCount, 33000);
      expect(sticky.latestPostAuthor, 'thuyvan');
      expect(sticky.latestPostAt, isNotNull);
      expect(sticky.prefixes, contains('đánh giá'));

      final regular = result.threads[1];
      expect(regular.summary.id, 'tai-chinh-15tr.1163758');
      expect(regular.summary.author, 'telzero');
      expect(regular.replyCount, 3);
      expect(regular.viewCount, 353);
      expect(regular.isUnread, isTrue);
      expect(regular.latestPostAuthor, 'quocsang06');
      expect(regular.latestPostUrl, '/t/tai-chinh-15tr.1163758/latest');
      expect(regular.startedAt, isNotNull);
    });
  });
}
