import 'package:equatable/equatable.dart';

class ForumCategory extends Equatable {
  const ForumCategory({
    required this.id,
    required this.title,
    required this.section,
    this.description,
    this.iconName,
  });

  final String id;
  final String title;
  final String section;
  final String? description;
  final String? iconName;

  @override
  List<Object?> get props => [id, title, section, description, iconName];
}

class ForumSummary extends Equatable {
  const ForumSummary({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
