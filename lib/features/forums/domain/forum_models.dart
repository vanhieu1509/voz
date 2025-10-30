import 'package:equatable/equatable.dart';

class ForumCategory extends Equatable {
  const ForumCategory({
    required this.id,
    required this.title,
    required this.section,
    required this.url,
    this.description,
    this.threadCount,
    this.messageCount,
    this.latestThreadTitle,
    this.latestThreadUrl,
    this.latestThreadAuthor,
    this.latestThreadTimestamp,
    this.latestThreadRelativeTime,
    this.latestThreadAvatarUrl,
    this.iconName,
  });

  final String id;
  final String title;
  final String section;
  final String url;
  final String? description;
  final String? threadCount;
  final String? messageCount;
  final String? latestThreadTitle;
  final String? latestThreadUrl;
  final String? latestThreadAuthor;
  final String? latestThreadTimestamp;
  final String? latestThreadRelativeTime;
  final String? latestThreadAvatarUrl;
  final String? iconName;

  @override
  List<Object?> get props => [
        id,
        title,
        section,
        url,
        description,
        threadCount,
        messageCount,
        latestThreadTitle,
        latestThreadUrl,
        latestThreadAuthor,
        latestThreadTimestamp,
        latestThreadRelativeTime,
        latestThreadAvatarUrl,
        iconName,
      ];
}

class ForumSummary extends Equatable {
  const ForumSummary({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
