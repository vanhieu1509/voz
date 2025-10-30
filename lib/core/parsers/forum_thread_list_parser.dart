import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;

import '../../features/threads/domain/thread_models.dart';
import 'pagination_parser.dart';

class ForumThreadListParser {
  ForumThreadListPage parse(
    String document, {
    int page = 1,
  }) {
    final doc = html.parse(document);
    final threads = <ForumThreadListItem>[];

    for (final element in doc.querySelectorAll('.structItem--thread')) {
      final link = element.querySelector('.structItem-title a');
      if (link == null) {
        continue;
      }

      final threadUrl = link.attributes['href'] ?? '';
      final threadId = _extractThreadId(threadUrl);
      if (threadId == null || threadId.isEmpty) {
        continue;
      }

      final title = _cleanText(link.text) ?? 'Thread';
      final authorElement = element.querySelector('.structItem-parts .username');
      final author = _cleanText(authorElement?.text) ?? element.attributes['data-author'] ?? 'vozUser';
      final authorId = authorElement?.attributes['data-user-id'];
      final authorProfileUrl = authorElement?.attributes['href'];

      final authorAvatarUrl = element
          .querySelector('.structItem-cell--icon img')
          ?.attributes['src'];

      final metaValues = element.querySelectorAll('.structItem-cell--meta dd');
      final replies = _parseCount(
        metaValues.isNotEmpty ? metaValues.first.text : null,
      );
      final views = _parseCount(
        metaValues.length > 1 ? metaValues[1].text : null,
      );

      final latestLink = element.querySelector('.structItem-cell--latest a');
      final latestPostUrl = latestLink?.attributes['href'];
      final latestPostTime = element.querySelector('.structItem-latestDate');
      final latestPostTimestamp = _parseDate(latestPostTime);
      final latestPostAuthor = _cleanText(
        element.querySelector('.structItem-cell--latest .username')?.text,
      );
      final latestAvatarUrl = element
          .querySelector('.structItem-cell--iconEnd img')
          ?.attributes['src'];

      final startedTime = element.querySelector('.structItem-startDate time');
      final startedAt = _parseDate(startedTime);

      final prefixes = element
          .querySelectorAll('.structItem-title .label')
          .map((label) => _cleanText(label.text))
          .whereType<String>()
          .toList(growable: false);

      final summary = ThreadSummary(id: threadId, title: title, author: author);

      threads.add(
        ForumThreadListItem(
          summary: summary,
          url: threadUrl,
          prefixes: prefixes,
          replyCount: replies,
          viewCount: views,
          startedAt: startedAt,
          latestPostAt: latestPostTimestamp,
          latestPostAuthor: latestPostAuthor,
          latestPostUrl: latestPostUrl,
          latestPostAvatarUrl: latestAvatarUrl,
          authorAvatarUrl: authorAvatarUrl,
          authorId: authorId,
          authorProfileUrl: authorProfileUrl,
          isLocked: element.querySelector('.structItem-status--locked') != null,
          isSticky: element.querySelector('.structItem-status--sticky') != null ||
              element.classes.contains('structItem--sticky'),
          isUnread: element.classes.contains('is-unread'),
        ),
      );
    }

    final pagination = parseThreadPagination(doc, fallbackPage: page);

    return ForumThreadListPage(threads: threads, pagination: pagination);
  }
}

final forumThreadListParserProvider =
    Provider<ForumThreadListParser>((ref) => ForumThreadListParser());

String? _extractThreadId(String url) {
  final match = RegExp(r'/t/([^/]+)/').firstMatch(url);
  return match?.group(1);
}

DateTime? _parseDate(Element? element) {
  if (element == null) {
    return null;
  }
  final datetime = element.attributes['datetime'];
  if (datetime != null && datetime.isNotEmpty) {
    final parsed = DateTime.tryParse(datetime);
    if (parsed != null) {
      return parsed;
    }
  }
  final timestamp = element.attributes['data-timestamp'];
  if (timestamp != null) {
    final intTimestamp = int.tryParse(timestamp);
    if (intTimestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(intTimestamp * 1000, isUtc: true).toLocal();
    }
  }
  return null;
}

int? _parseCount(String? text) {
  if (text == null) {
    return null;
  }
  final normalized = text.trim().toLowerCase();
  final multiplier = normalized.endsWith('k')
      ? 1000
      : normalized.endsWith('m')
          ? 1000000
          : 1;
  final valueString = normalized.replaceAll(RegExp(r'[^0-9\.]'), '');
  if (valueString.isEmpty) {
    return null;
  }
  final value = double.tryParse(valueString);
  if (value == null) {
    return null;
  }
  return (value * multiplier).round();
}

String? _cleanText(String? value) {
  if (value == null) {
    return null;
  }
  final text = value.replaceAll(RegExp(r'\s+'), ' ').trim();
  return text.isEmpty ? null : text;
}
