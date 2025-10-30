import 'package:equatable/equatable.dart';

class ThreadSummary extends Equatable {
  const ThreadSummary({required this.id, required this.title, required this.author});

  final String id;
  final String title;
  final String author;

  @override
  List<Object?> get props => [id, title, author];
}

class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.author,
    required this.content,
    required this.postedAt,
    this.avatarUrl,
  });

  final String id;
  final String author;
  final String content;
  final DateTime postedAt;
  final String? avatarUrl;

  @override
  List<Object?> get props => [id, author, content, postedAt, avatarUrl];
}

class ThreadPage extends Equatable {
  const ThreadPage({required this.thread, required this.posts, required this.page});

  final ThreadSummary thread;
  final List<PostModel> posts;
  final int page;

  @override
  List<Object?> get props => [thread, posts, page];
}

class ComposerParams {
  const ComposerParams({required this.threadId, this.quotePost});

  final String threadId;
  final PostModel? quotePost;
}
