import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html/parser.dart' as html;
import 'package:html/dom.dart';

import '../../features/forums/domain/forum_models.dart';

class ForumParser {
  List<ForumCategory> parseCategories(String document) {
    final doc = html.parse(document);
    final containers = doc.querySelectorAll('.block-container');
    final categories = <ForumCategory>[];

    for (final container in containers) {
      final nodes = container.querySelectorAll('.node--forum');
      if (nodes.isEmpty) {
        continue;
      }

      final sectionTitle = _extractSectionTitle(container) ?? 'Forums';
      for (final node in nodes) {
        final link = node.querySelector('.node-title a');
        if (link == null) {
          continue;
        }

        final url = link.attributes['href'] ?? '';
        final id = _extractNodeId(node, url);
        if (id.isEmpty) {
          continue;
        }

        final description = _extractDescription(node, link);
        final threadCount = _extractStat(node, 'Threads');
        final messageCount = _extractStat(node, 'Messages');

        final latestThreadTitle = _cleanText(node.querySelector('.node-extra-title')?.text);
        final latestThreadUrl = node.querySelector('.node-extra-title')?.attributes['href'];
        final latestThreadAuthor = _cleanText(
          node.querySelector('.node-extra-user .username')?.text,
        );

        final timeElement = node.querySelector('.node-extra-date');
        final latestThreadTimestamp = timeElement?.attributes['datetime'] ??
            timeElement?.attributes['data-timestamp'];
        final latestThreadRelativeTime = _cleanText(timeElement?.text);

        final avatarUrl = node.querySelector('.node-extra-icon img')?.attributes['src'];

        categories.add(
          ForumCategory(
            id: id,
            title: _cleanText(link.text) ?? 'Unknown',
            section: sectionTitle,
            url: url,
            description: description,
            threadCount: threadCount,
            messageCount: messageCount,
            latestThreadTitle: latestThreadTitle,
            latestThreadUrl: latestThreadUrl,
            latestThreadAuthor: latestThreadAuthor,
            latestThreadTimestamp: latestThreadTimestamp,
            latestThreadRelativeTime: latestThreadRelativeTime,
            latestThreadAvatarUrl: avatarUrl,
          ),
        );
      }
    }

    return categories;
  }

  String? _extractSectionTitle(Element container) {
    final headerLink = container.querySelector('.block-header a');
    if (headerLink != null) {
      final value = _cleanText(headerLink.text);
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    final header = container.querySelector('.block-header');
    return _cleanText(header?.text);
  }

  String _extractNodeId(Element node, String url) {
    final fromDataAttribute = node.attributes['data-node-id'];
    if (fromDataAttribute != null && fromDataAttribute.isNotEmpty) {
      return fromDataAttribute;
    }

    final matchFromUrl = RegExp(r'/f/([^/]+)/?').firstMatch(url);
    if (matchFromUrl != null && matchFromUrl.groupCount >= 1) {
      return matchFromUrl.group(1)!;
    }

    for (final className in node.classes) {
      final match = RegExp(r'node--id(\d+)').firstMatch(className);
      if (match != null) {
        return match.group(1)!;
      }
    }

    return '';
  }

  String? _extractDescription(Element node, Element link) {
    final description = node.querySelector('.node-description')?.text.trim();
    if (description != null && description.isNotEmpty) {
      return description;
    }

    final shortcut = link.attributes['data-shortcut'];
    if (shortcut != null) {
      final cleaned = shortcut.trim();
      if (cleaned.isNotEmpty && cleaned != 'node-description') {
        return cleaned;
      }
    }

    final title = link.attributes['title'];
    if (title != null && title.trim().isNotEmpty) {
      return title.trim();
    }

    return null;
  }

  String? _extractStat(Element node, String label) {
    final statsContainers = node.querySelectorAll('.node-statsMeta .pairs, .node-stats .pairs');
    for (final stat in statsContainers) {
      final statLabel = _cleanText(stat.querySelector('dt')?.text);
      if (statLabel != null && statLabel.toLowerCase() == label.toLowerCase()) {
        return _cleanText(stat.querySelector('dd')?.text);
      }
    }
    return null;
  }

  String? _cleanText(String? text) {
    if (text == null) {
      return null;
    }
    final value = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return value.isEmpty ? null : value;
  }
}

final forumParserProvider = Provider<ForumParser>((ref) => ForumParser());
