import 'package:equatable/equatable.dart';

class ThreadSummary extends Equatable {
  const ThreadSummary({required this.id, required this.title, required this.author});

  final String id;
  final String title;
  final String author;

  @override
  List<Object?> get props => [id, title, author];
}

class ForumThreadListItem extends Equatable {
  const ForumThreadListItem({
    required this.summary,
    required this.url,
    this.prefixes = const <String>[],
    this.replyCount,
    this.viewCount,
    this.startedAt,
    this.latestPostAuthor,
    this.latestPostAt,
    this.latestPostUrl,
    this.latestPostAvatarUrl,
    this.authorAvatarUrl,
    this.authorId,
    this.authorProfileUrl,
    this.isSticky = false,
    this.isLocked = false,
    this.isUnread = false,
  });

  final ThreadSummary summary;
  final String url;
  final List<String> prefixes;
  final int? replyCount;
  final int? viewCount;
  final DateTime? startedAt;
  final String? latestPostAuthor;
  final DateTime? latestPostAt;
  final String? latestPostUrl;
  final String? latestPostAvatarUrl;
  final String? authorAvatarUrl;
  final String? authorId;
  final String? authorProfileUrl;
  final bool isSticky;
  final bool isLocked;
  final bool isUnread;

  @override
  List<Object?> get props => [
        summary,
        url,
        prefixes,
        replyCount,
        viewCount,
        startedAt,
        latestPostAuthor,
        latestPostAt,
        latestPostUrl,
        latestPostAvatarUrl,
        authorAvatarUrl,
        authorId,
        authorProfileUrl,
        isSticky,
        isLocked,
        isUnread,
      ];
}

class PostModel extends Equatable {
  const PostModel({
    required this.id,
    required this.author,
    required this.content,
    required this.postedAt,
    this.avatarUrl,
    this.authorId,
    this.authorProfileUrl,
    this.authorTitle,
    this.permalink,
    this.position,
  });

  final String id;
  final String author;
  final String content;
  final DateTime postedAt;
  final String? avatarUrl;
  final String? authorId;
  final String? authorProfileUrl;
  final String? authorTitle;
  final String? permalink;
  final int? position;

  @override
  List<Object?> get props => [
        id,
        author,
        content,
        postedAt,
        avatarUrl,
        authorId,
        authorProfileUrl,
        authorTitle,
        permalink,
        position,
      ];
}

class ThreadPagination extends Equatable {
  const ThreadPagination({
    required this.currentPage,
    required this.totalPages,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  final int currentPage;
  final int totalPages;
  final String? nextPageUrl;
  final String? previousPageUrl;

  bool get hasNextPage => currentPage < totalPages;

  bool get hasPreviousPage => currentPage > 1;

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        nextPageUrl,
        previousPageUrl,
      ];
}

class ThreadPage extends Equatable {
  const ThreadPage({
    required this.thread,
    required this.posts,
    required this.pagination,
  });

  final ThreadSummary thread;
  final List<PostModel> posts;
  final ThreadPagination pagination;

  int get page => pagination.currentPage;

  @override
  List<Object?> get props => [thread, posts, pagination];
}

class ForumThreadListPage extends Equatable {
  const ForumThreadListPage({
    required this.threads,
    required this.pagination,
  });

  final List<ForumThreadListItem> threads;
  final ThreadPagination pagination;

  @override
  List<Object?> get props => [threads, pagination];
}

class ComposerParams {
  const ComposerParams({required this.threadId, this.quotePost});

  final String threadId;
  final PostModel? quotePost;
}
