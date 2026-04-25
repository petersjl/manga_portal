import 'package:flutter/material.dart';

import '../models/chapter.dart';

/// Reading state for a chapter group, used to style the corresponding tile.
enum ChapterReadState {
  /// No progress recorded — user hasn't started this chapter.
  unread,

  /// This is the chapter the user is currently partway through.
  reading,

  /// User has read past this chapter.
  read,
}

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
    this.readState = ChapterReadState.unread,
  });

  final List<Chapter> chapters;
  final String preferredLanguage;
  final void Function(String chapterId) onChapterSelected;
  final ChapterReadState readState;

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
        readState: widget.readState,
        onTap: () => widget.onChapterSelected(preferred.first.id),
      );
    }

    return _MultiGroupTile(
      label: title,
      chapters: preferred,
      readState: widget.readState,
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
    this.readState = ChapterReadState.unread,
  });

  final String label;
  final Chapter chapter;
  final VoidCallback onTap;
  final ChapterReadState readState;

  @override
  Widget build(BuildContext context) {
    final groupName = chapter.scanlationGroup?.name;
    final date = _formatDate(chapter.attributes.publishAt);
    final subtitle = [
      if (groupName != null) groupName,
      if (date.isNotEmpty) date,
    ].join(' · ');

    final isRead = readState == ChapterReadState.read;
    final isReading = readState == ChapterReadState.reading;
    final dimColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    final tile = ListTile(
      title: Text(
        label,
        style: isRead ? TextStyle(color: dimColor) : null,
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: isRead ? TextStyle(color: dimColor) : null,
            )
          : null,
      trailing: isRead
          ? Icon(Icons.check_circle_outline, color: dimColor, size: 20)
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );

    if (isReading) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
        ),
        child: tile,
      );
    }

    return tile;
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
    this.readState = ChapterReadState.unread,
  });

  final String label;
  final List<Chapter> chapters;
  final bool expanded;
  final VoidCallback onToggle;
  final void Function(String chapterId) onChapterSelected;
  final ChapterReadState readState;

  @override
  Widget build(BuildContext context) {
    final isRead = readState == ChapterReadState.read;
    final isReading = readState == ChapterReadState.reading;
    final dimColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    final header = ListTile(
      title: Text(
        label,
        style: isRead ? TextStyle(color: dimColor) : null,
      ),
      subtitle: Text(
        '${chapters.length} translations',
        style: isRead ? TextStyle(color: dimColor) : null,
      ),
      trailing: Icon(
        expanded ? Icons.expand_less : Icons.expand_more,
        color: isRead ? dimColor : null,
      ),
      onTap: onToggle,
    );

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isReading
            ? DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
                child: header,
              )
            : header,
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

    return column;
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
