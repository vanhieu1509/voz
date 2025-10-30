import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:voz_forum_app/core/parsers/thread_parser.dart';

void main() {
  test('thread parser extracts posts correctly', () {
    final html = File('test/fixtures/thread_page.html').readAsStringSync();
    final parser = ThreadParser();
    final page = parser.parseThread(html);

    expect(page.thread.id, '123');
    expect(page.posts, isNotEmpty);
    expect(page.posts.first.author, 'User A');
    expect(page.posts.first.content, contains('Hello world'));
  });
}
