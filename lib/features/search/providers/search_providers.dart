import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/search_repository.dart';
import '../domain/search_models.dart';

final searchResultsProvider = FutureProvider.family<List<SearchResult>, SearchRequest>((ref, request) {
  return ref.watch(searchRepositoryProvider).search(request.query, request.scope, request.page);
});

class SearchRequest {
  SearchRequest({required this.query, this.scope = 'all', this.page = 1});

  final String query;
  final String scope;
  final int page;
}
