import 'package:equatable/equatable.dart';

class SearchResult extends Equatable {
  const SearchResult({required this.threadId, required this.title, required this.snippet});

  final String threadId;
  final String title;
  final String snippet;

  @override
  List<Object?> get props => [threadId, title, snippet];
}
