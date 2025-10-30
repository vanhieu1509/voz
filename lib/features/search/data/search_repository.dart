import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/search_models.dart';

class SearchRepository {
  SearchRepository(this._reader);

  final Reader _reader;

  Future<List<SearchResult>> search(String query, String scope, int page) async {
    return List.generate(
      5,
      (index) => SearchResult(
        threadId: '$scope-$page-$index',
        title: 'Result $index for $query',
        snippet: 'Snippet for result $index',
      ),
    );
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  ref.watch(dioProvider);
  return SearchRepository(ref.read);
});
