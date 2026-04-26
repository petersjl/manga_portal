import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';
import '../providers/settings_provider.dart';

// ── Label maps ────────────────────────────────────────────────────────────────

const _languages = [
  ('en', 'English'),
  ('ja', 'Japanese'),
  ('zh', 'Chinese (Simplified)'),
  ('zh-hk', 'Chinese (Traditional)'),
  ('ko', 'Korean'),
  ('fr', 'French'),
  ('es', 'Spanish'),
  ('es-la', 'Spanish (Latin America)'),
  ('it', 'Italian'),
  ('de', 'German'),
  ('ru', 'Russian'),
  ('pt', 'Portuguese'),
  ('pt-br', 'Portuguese (Brazil)'),
];

const _contentRatings = [
  ('safe', 'Safe'),
  ('suggestive', 'Suggestive'),
  ('erotica', 'Erotica'),
  ('pornographic', 'Pornographic'),
];

const _themes = [
  (ThemeMode.system, 'System'),
  (ThemeMode.light, 'Light'),
  (ThemeMode.dark, 'Dark'),
];

// ── Page ─────────────────────────────────────────────────────────────────────

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Appearance ────────────────────────────────────────────────────
          const _SectionHeader(label: 'Appearance'),
          _DropdownTile<ThemeMode>(
            label: 'Theme',
            value: settings.themeMode,
            items: _themes.map((e) => (e.$1, e.$2)).toList(),
            onChanged: notifier.setThemeMode,
          ),

          // ── Content ───────────────────────────────────────────────────────
          const _SectionHeader(label: 'Content'),
          _DropdownTile<String>(
            label: 'Preferred language',
            value: settings.preferredLanguage,
            items: _languages.map((e) => (e.$1, e.$2)).toList(),
            onChanged: notifier.setPreferredLanguage,
          ),
          _DropdownTile<String>(
            label: 'Maximum content rating',
            subtitle: 'Includes all tiers at or below the selected rating.',
            value: settings.maxContentRating,
            items: _contentRatings.map((e) => (e.$1, e.$2)).toList(),
            onChanged: notifier.setMaxContentRating,
          ),

          // ── Reading ───────────────────────────────────────────────────────
          const _SectionHeader(label: 'Reading'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Image quality',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Data saver uses less bandwidth at the cost of image quality.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(150),
                      ),
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'data', label: Text('Full')),
                    ButtonSegment(
                        value: 'data-saver', label: Text('Data saver')),
                  ],
                  selected: {settings.imageQuality},
                  onSelectionChanged: (values) =>
                      notifier.setImageQuality(values.first),
                ),
              ],
            ),
          ),

          // ── Reading history ───────────────────────────────────────────────
          const _SectionHeader(label: 'Reading history'),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Clear reading history'),
            subtitle: const Text(
              'Removes all progress and read chapter data from this device.',
            ),
            onTap: () => _confirmClear(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear reading history?'),
        content: const Text(
          'This will remove all reading progress and read chapter markers '
          'from this device. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final service = await ref.read(localProgressServiceProvider.future);
    await service.clearAllProgress();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reading history cleared.')),
      );
    }
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

/// A ListTile that contains a labelled dropdown.
class _DropdownTile<T> extends StatelessWidget {
  const _DropdownTile({
    required this.label,
    this.subtitle,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? subtitle;
  final T value;
  final List<(T, String)> items;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          helperText: subtitle,
          helperMaxLines: 2,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e.$1, child: Text(e.$2)))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
