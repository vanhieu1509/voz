import 'dart:io';

import 'package:test/test.dart';

import 'package:voz_forum_app/core/parsers/forum_parser.dart';

void main() {
  group('ForumParser', () {
    test('parses forum categories with metadata', () {
      final parser = ForumParser();
      final document = File('test/fixtures/forum_section.html').readAsStringSync();

      final categories = parser.parseCategories(document);

      expect(categories, isNotEmpty);
      expect(categories.first.section, 'Máy tính');
      expect(categories.first.id, 'tu-van-cau-hinh.70');
      expect(categories.first.title, 'Tư vấn cấu hình');
      expect(categories.first.threadCount, '5.7K');
      expect(categories.first.messageCount, '59.9K');
      expect(
        categories.first.latestThreadTitle,
        'Max 14tr cần máy làm đồ họa cơ bản autocad, shop, revit, không cần màn hình',
      );
      expect(categories.first.latestThreadAuthor, 'quocsang06');
      expect(categories.first.latestThreadTimestamp, '2025-10-30T11:15:04+0700');
      expect(categories.first.latestThreadRelativeTime, '13 minutes ago');
      expect(
        categories.first.latestThreadAvatarUrl,
        'https://data.voz.vn/avatars/s/1028/1028242.jpg?1733740102',
      );

      final second = categories[1];
      expect(second.id, 'overclocking-cooling-modding.6');
      expect(second.section, 'Máy tính');
      expect(second.latestThreadAuthor, 'maybe990');
      expect(second.latestThreadRelativeTime, '17 minutes ago');
      expect(second.threadCount, '2.2K');
      expect(second.messageCount, '57.3K');
    });
  });
}
