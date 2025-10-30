import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:voz_forum_app/core/parsers/thread_parser.dart';

void main() {
  test('thread parser extracts posts with metadata correctly', () {
    final html = File('test/fixtures/thread_page.html').readAsStringSync();
    final parser = ThreadParser();
    final page = parser.parseThread(html, page: 1, threadIdFallback: 'fallback-id');

    expect(page.thread.id, '1163898');
    expect(page.thread.title,
        'Cô gái TP.HCM cầm 300 triệu mua nhà, lãi 1 tỷ đồng sau 2 năm');
    expect(page.thread.author, '17.5cm');
    expect(page.page, 1);
    expect(page.pagination.totalPages, 7);
    expect(page.pagination.hasNextPage, isTrue);
    expect(page.pagination.nextPageUrl,
        '/t/co-gai-tp-hcm-cam-300-trieu-mua-nha-lai-1-ty-%C4%91ong-sau-2-nam.1163898/page-2');
    expect(page.pagination.hasPreviousPage, isFalse);
    expect(page.pagination.previousPageUrl, isNull);
    expect(page.posts, hasLength(2));
    final firstPost = page.posts.first;
    expect(firstPost.author, '17.5cm');
    expect(firstPost.authorId, '1329102');
    expect(firstPost.authorProfileUrl, '/u/17-5cm.1329102/');
    expect(firstPost.authorTitle, 'Member');
    expect(firstPost.avatarUrl, 'https://statics.voz.tech/avatars/17/17-5cm.jpg');
    expect(firstPost.content, contains('Bài viết mở đầu.'));
    expect(firstPost.permalink,
        'https://voz.vn/p/39304180/');
    expect(firstPost.position, 1);
    expect(firstPost.postedAt,
        DateTime.parse('2025-10-29T08:13:04+07:00'));

    final secondPost = page.posts.last;
    expect(secondPost.author, 'uxlove378');
    expect(secondPost.authorId, '1126523');
    expect(secondPost.authorProfileUrl, '/u/uxlove378.1126523/');
    expect(secondPost.authorTitle, 'Senior Member');
    expect(secondPost.avatarUrl, isNull);
    expect(secondPost.content, contains('hóng các chuyên gia vào cmt'));
    expect(secondPost.permalink,
        'https://voz.vn/p/39304182/');
    expect(secondPost.position, 2);
    expect(secondPost.postedAt,
        DateTime.parse('2025-10-29T08:33:41+07:00'));
  });
}
