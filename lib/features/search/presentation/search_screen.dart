import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/search_providers.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryController = useTextEditingController();
    final scope = useState('all');
    final searchRequest = useState<SearchRequest?>(null);

    final results = searchRequest.value == null
        ? const AsyncValue<List<dynamic>>.data([])
        : ref.watch(searchResultsProvider(searchRequest.value!));

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: queryController,
              decoration: const InputDecoration(labelText: 'Keyword'),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: scope.value,
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'thread', child: Text('Thread titles')),
                DropdownMenuItem(value: 'user', child: Text('Author')),
              ],
              onChanged: (value) => scope.value = value ?? 'all',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                searchRequest.value = SearchRequest(query: queryController.text, scope: scope.value);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: results.when(
                data: (items) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.snippet),
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
