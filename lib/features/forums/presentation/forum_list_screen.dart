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
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < categories.length; i++) ...[
                _ForumNodeTile(
                  category: categories[i],
                  onTap: () => onCategoryTap(categories[i]),
                ),
                if (i != categories.length - 1) const Divider(height: 1, thickness: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ForumNodeTile extends StatelessWidget {
  const _ForumNodeTile({required this.category, required this.onTap});

  final ForumCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatar = _buildAvatar(theme);
    final stats = <Widget>[];
    if (category.threadCount != null) {
      stats.add(
        _StatBadge(
          icon: Icons.forum_outlined,
          label: 'Threads',
          value: category.threadCount!,
        ),
      );
    }
    if (category.messageCount != null) {
      stats.add(
        _StatBadge(
          icon: Icons.message_outlined,
          label: 'Messages',
          value: category.messageCount!,
        ),
      );
    }

    final latestMetaParts = <String>[];
    if (category.latestThreadAuthor != null) {
      latestMetaParts.add(category.latestThreadAuthor!);
    }
    if (category.latestThreadRelativeTime != null) {
      latestMetaParts.add(category.latestThreadRelativeTime!);
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if ((category.description?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 4),
                        Text(
                          category.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            if (stats.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: stats,
              ),
            ],
            if (category.latestThreadTitle != null) ...[
              const SizedBox(height: 12),
              Text(
                category.latestThreadTitle!,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (latestMetaParts.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    latestMetaParts.join(' • '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    final avatarUrl = category.latestThreadAvatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
        backgroundColor: theme.colorScheme.surfaceVariant,
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
      child: Icon(
        Icons.forum_outlined,
        color: theme.colorScheme.primary,
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
