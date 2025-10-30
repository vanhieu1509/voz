import 'package:html/parser.dart' as html;

import '../../features/search/domain/search_models.dart';

class SearchParser {
  List<SearchResult> parseResults(String document) {
    final doc = html.parse(document);
    return doc.querySelectorAll('.contentRow').map((element) {
      final threadId = element.attributes['data-content-id'] ?? '';
      final title = element.querySelector('.contentRow-title')?.text.trim() ?? 'Result';
      final snippet = element.querySelector('.contentRow-snippet')?.text.trim() ?? '';
      return SearchResult(threadId: threadId, title: title, snippet: snippet);
    }).toList();
  }
}
