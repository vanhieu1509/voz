import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart' as html;

import '../../features/threads/domain/thread_models.dart';
import 'pagination_parser.dart';

class ThreadParser {
  ThreadPage parseThread(
    String document, {
    int page = 1,
    String? threadIdFallback,
  }) {
    final doc = html.parse(document);

    final threadContainer = doc.querySelector('[data-thread-id]');
    final threadId =
        threadContainer?.attributes['data-thread-id'] ?? threadIdFallback ?? '';

    final header = doc.querySelector('.p-body-header');
    final threadTitle = header
            ?.querySelector('h1.p-title-value')
            ?.text
            .trim() ??
        doc.querySelector('h1.p-title-value')?.text.trim() ??
        'Thread';

    final headerStarter = header
        ?.querySelector('.p-description .username')
        ?.text
        .trim();
    final starterAuthor = headerStarter?.isNotEmpty == true
        ? headerStarter
        : doc
            .querySelector('.message-threadStarterPost .message-name')
            ?.text
            .trim();

    final pagination = parseThreadPagination(doc, fallbackPage: page);
    final currentPage = pagination.currentPage;

    final posts = doc.querySelectorAll('.message').map((element) {
      final id = element.attributes['data-content'] ??
          element.attributes['data-message-id'] ??
          element.id ??
          '';

      final authorElement =
          element.querySelector('.message-name a.username') ??
              element.querySelector('.message-name a') ??
              element.querySelector('.message-name');
      final rawAuthor = authorElement?.text;
      final author = (rawAuthor != null && rawAuthor.trim().isNotEmpty)
          ? rawAuthor.trim()
          : element.attributes['data-author'] ?? 'User';
      final authorProfileUrl = authorElement?.attributes['href'];
      final authorId = authorElement?.attributes['data-user-id'] ??
          element.attributes['data-author-id'];
      final authorTitle =
          element.querySelector('.message-userTitle')?.text.trim();

      final content = element
              .querySelector('.message-content .bbWrapper')
              ?.innerHtml
              .trim() ??
          element.querySelector('.message-body')?.innerHtml.trim() ??
          element.querySelector('.message-body')?.text.trim() ??
          '';

      String? avatarUrl;
      final avatarImage = element.querySelector('.message-avatar img');
      if (avatarImage != null) {
        avatarUrl = avatarImage.attributes['src'] ??
            avatarImage.attributes['data-src'] ??
            avatarImage.attributes['data-lazy-src'];
      }

      final timeElement = element.querySelector('time');
      final datetimeAttr = timeElement?.attributes['datetime'];
      final dataTimestampAttr = timeElement?.attributes['data-timestamp'];
      final dataTimeAttr = timeElement?.attributes['data-time'];
      var postedAt = DateTime.now();

      if (datetimeAttr != null) {
        postedAt = DateTime.tryParse(datetimeAttr) ?? postedAt;
      } else if (dataTimestampAttr != null) {
        final timestamp = int.tryParse(dataTimestampAttr);
        if (timestamp != null) {
          postedAt = DateTime.fromMillisecondsSinceEpoch(
            timestamp * 1000,
            isUtc: true,
          ).toLocal();
        }
      } else if (dataTimeAttr != null) {
        final timestamp = int.tryParse(dataTimeAttr);
        if (timestamp != null) {
          postedAt = DateTime.fromMillisecondsSinceEpoch(
            timestamp * 1000,
            isUtc: true,
          ).toLocal();
        }
      }

      final permalink = element.attributes['itemid'] ??
          element
              .querySelector('.message-attribution-main a[rel="nofollow"]')
              ?.attributes['href'];

      final positionText = element
          .querySelector(
              '.message-attribution-opposite a[href*="post-"]:not(.message-attribution-gadget)')
          ?.text
          .trim();
      final position = _extractInt(positionText);

      return PostModel(
        id: id,
        author: author,
        content: content,
        postedAt: postedAt,
        avatarUrl: (avatarUrl != null && avatarUrl.isNotEmpty) ? avatarUrl : null,
        authorId: authorId,
        authorProfileUrl: authorProfileUrl,
        authorTitle: (authorTitle != null && authorTitle.isNotEmpty)
            ? authorTitle
            : null,
        permalink: permalink,
        position: position,
      );
    }).toList();

    final threadAuthor = starterAuthor ?? (posts.isNotEmpty ? posts.first.author : '');

    return ThreadPage(
      thread: ThreadSummary(
        id: threadId,
        title: threadTitle,
        author: threadAuthor,
      ),
      posts: posts,
      pagination: pagination,
    );
  }
}

final threadParserProvider = Provider<ThreadParser>((ref) => ThreadParser());

int? _extractInt(String? source) {
  if (source == null) {
    return null;
  }

  final match = RegExp(r'-?\d+').firstMatch(source.replaceAll(',', ''));
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(0) ?? '');
}
