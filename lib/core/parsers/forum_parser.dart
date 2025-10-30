import 'package:html/parser.dart' as html;
import 'package:html/dom.dart';

import '../../features/forums/domain/forum_models.dart';

class ForumParser {
  List<ForumCategory> parseCategories(String document) {
    final doc = html.parse(document);
    final elements = doc.querySelectorAll('.node--forum');
    return elements
        .map(
          (element) => ForumCategory(
            id: element.attributes['data-node-id'] ?? '',
            title: element.querySelector('.node-title')?.text.trim() ?? 'Unknown',
            description: element.querySelector('.node-description')?.text.trim() ?? '',
          ),
        )
        .toList();
  }
}
