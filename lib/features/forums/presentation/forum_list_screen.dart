import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/forum_providers.dart';
import '../../../shared/localization/app_localizations.dart';
import '../domain/forum_models.dart';
import '../../threads/domain/thread_models.dart';

class ForumListScreen extends ConsumerWidget {
  const ForumListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('forums'))),
      body: categories.when(
        data: (items) {
          final grouped = <String, List<ForumCategory>>{};
          for (final category in items) {
            grouped.putIfAbsent(category.section, () => []).add(category);
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              for (final entry in grouped.entries) ...[
                _ForumSection(
                  title: entry.key,
                  categories: entry.value,
                  onCategoryTap: (category) {
                    context.push(
                      '/home/threads/${category.id}',
                      extra: ForumSummary(id: category.id, title: category.title),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ForumSection extends StatelessWidget {
  const _ForumSection({
    required this.title,
    required this.categories,
    required this.onCategoryTap,
  });

  final String title;
  final List<ForumCategory> categories;
  final ValueChanged<ForumCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: category,
              onTap: () => onCategoryTap(category),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.onTap});

  final ForumCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = _iconFromName(category.iconName);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if ((category.description?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 6),
                Text(
                  category.description!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconFromName(String? iconName) {
  switch (iconName) {
    case 'campaign':
      return Icons.campaign_outlined;
    case 'emoji_objects':
      return Icons.emoji_objects_outlined;
    case 'article':
      return Icons.article_outlined;
    case 'rate_review':
      return Icons.rate_review_outlined;
    case 'school':
      return Icons.school_outlined;
    case 'support_agent':
      return Icons.support_agent;
    case 'bolt':
      return Icons.bolt_outlined;
    case 'memory':
      return Icons.memory_outlined;
    case 'precision_manufacturing':
      return Icons.precision_manufacturing;
    case 'desktop_windows':
      return Icons.desktop_windows_outlined;
    case 'forum':
      return Icons.forum_outlined;
    case 'sports_esports':
      return Icons.sports_esports_outlined;
    case 'dns':
      return Icons.dns_outlined;
    case 'developer_board':
      return Icons.developer_board_outlined;
    default:
      return Icons.forum_outlined;
  }
}
