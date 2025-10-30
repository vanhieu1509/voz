import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/forum_models.dart';

class ForumRepository {
  ForumRepository(this._reader);

  final Reader _reader;

  Future<List<ForumCategory>> listCategories() async {
    // Placeholder implementation.
    return const [
      ForumCategory(id: '1', title: 'News', description: 'Latest updates'),
      ForumCategory(id: '2', title: 'Tech', description: 'Technology discussions'),
    ];
  }

  Future<List<ForumSummary>> listThreads(String categoryId, int page) async {
    // Placeholder implementation.
    return List.generate(
      10,
      (index) => ForumSummary(id: '$categoryId-$page-$index', title: 'Thread $index'),
    );
  }
}

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  ref.watch(dioProvider); // ensure dependency
  return ForumRepository(ref.read);
});
