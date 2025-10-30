import 'package:equatable/equatable.dart';

class ForumCategory extends Equatable {
  const ForumCategory({required this.id, required this.title, required this.description});

  final String id;
  final String title;
  final String description;

  @override
  List<Object?> get props => [id, title, description];
}

class ForumSummary extends Equatable {
  const ForumSummary({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}
