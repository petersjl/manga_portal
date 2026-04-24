import 'package:flutter/material.dart';

import '../models/chapter.dart';

/// Displays all versions of a single chapter number.
///
/// Receives [chapters] — all [Chapter] objects that share the same chapter
/// number — and [preferredLanguage] to decide how to present them:
///
/// - **One group in preferred language**: single tappable row.
/// - **Multiple groups in preferred language**: collapsed row with an expand
///   toggle that reveals all groups inline.
/// - **No groups in preferred language**: subdued, non-interactive row with a
///   note indicating the chapter is unavailable in the preferred language.
class ChapterListTile extends StatefulWidget {
  const ChapterListTile({
    super.key,
    required this.chapters,
    required this.preferredLanguage,
    required this.onChapterSelected,
  });

  final List<Chapter> chapters;
  final String preferredLanguage;
  final void Function(String chapterId) onChapterSelected;

  @override
  State<ChapterListTile> createState() => _ChapterListTileState();
}

class _ChapterListTileState extends State<ChapterListTile> {
  bool _expanded = false;

  List<Chapter> get _preferred => widget.chapters
      .where((c) => c.attributes.translatedLanguage == widget.preferredLanguage)
      .toList();

  @override
  Widget build(BuildContext context) {
    final preferred = _preferred;
    final chapterNumber = widget.chapters.first.attributes.chapterNumber;
    final title = _chapterLabel(chapterNumber);

    if (preferred.isEmpty) {
      return _UnavailableTile(
        label: title,
        preferredLanguage: widget.preferredLanguage,
      );
    }

    if (preferred.length == 1) {
      return _SingleGroupTile(
        label: title,
        chapter: preferred.first,
        onTap: () => widget.onChapterSelected(preferred.first.id),
      );
    }

    return _MultiGroupTile(
      label: title,
      chapters: preferred,
      expanded: _expanded,
      onToggle: () => setState(() => _expanded = !_expanded),
      onChapterSelected: widget.onChapterSelected,
    );
  }
}

String _chapterLabel(String? chapterNumber) =>
    chapterNumber != null ? 'Ch. $chapterNumber' : 'Oneshot';

String _formatDate(String? isoDate) {
  if (isoDate == null) return '';
  try {
    final dt = DateTime.parse(isoDate).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  } catch (_) {
    return '';
  }
}

// ── Single group ─────────────────────────────────────────────────────────────

class _SingleGroupTile extends StatelessWidget {
  const _SingleGroupTile({
    required this.label,
    required this.chapter,
    required this.onTap,
  });

  final String label;
  final Chapter chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final groupName = chapter.scanlationGroup?.name;
    final date = _formatDate(chapter.attributes.publishAt);
    final subtitle = [
      if (groupName != null) groupName,
      if (date.isNotEmpty) date,
    ].join(' · ');

    return ListTile(
      title: Text(label),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// ── Multiple groups ───────────────────────────────────────────────────────────

class _MultiGroupTile extends StatelessWidget {
  const _MultiGroupTile({
    required this.label,
    required this.chapters,
    required this.expanded,
    required this.onToggle,
    required this.onChapterSelected,
  });

  final String label;
  final List<Chapter> chapters;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(String chapterId) onChapterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(label),
          subtitle: Text('${chapters.length} translations'),
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: onToggle,
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: expanded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final chapter in chapters)
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 32, right: 16),
                        title: Text(
                          chapter.scanlationGroup?.name ?? 'Unknown Group',
                        ),
                        subtitle:
                            Text(_formatDate(chapter.attributes.publishAt)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => onChapterSelected(chapter.id),
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

// ── Not available in preferred language ──────────────────────────────────────

class _UnavailableTile extends StatelessWidget {
  const _UnavailableTile({
    required this.label,
    required this.preferredLanguage,
  });

  final String label;
  final String preferredLanguage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
      subtitle: Text(
        'Not available in $preferredLanguage',
        style: TextStyle(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
        ),
      ),
      enabled: false,
    );
  }
}
