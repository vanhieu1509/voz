import 'package:html/parser.dart' as html;

import '../../features/threads/domain/thread_models.dart';

class ThreadParser {
  ThreadPage parseThread(String document) {
    final doc = html.parse(document);
    final threadId = doc.querySelector('[data-thread-id]')?.attributes['data-thread-id'] ?? '0';
    final threadTitle = doc.querySelector('h1.p-title-value')?.text.trim() ?? 'Thread';
    final posts = doc.querySelectorAll('.message').map((element) {
      final id = element.attributes['data-message-id'] ?? '';
      final author = element.querySelector('.message-name')?.text.trim() ?? 'User';
      final content = element.querySelector('.message-body')?.innerHtml.trim() ?? '';
      return PostModel(
        id: id,
        author: author,
        content: content,
        postedAt: DateTime.now(),
      );
    }).toList();
    return ThreadPage(
      thread: ThreadSummary(id: threadId, title: threadTitle, author: posts.isNotEmpty ? posts.first.author : ''),
      posts: posts,
      page: 1,
    );
  }
}
