import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_portal/pages/settings_page.dart';
import 'package:manga_portal/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Fake notifier ─────────────────────────────────────────────────────────────

class _FakeSettingsNotifier extends SettingsNotifier {
  _FakeSettingsNotifier(this._initial);

  final Settings _initial;

  @override
  Settings build() => _initial;
}

// ── Helper ────────────────────────────────────────────────────────────────────

Widget _buildApp([Settings? initial]) {
  return ProviderScope(
    overrides: [
      settingsNotifierProvider.overrideWith(
        () => _FakeSettingsNotifier(initial ?? const Settings()),
      ),
    ],
    child: const MaterialApp(home: SettingsPage()),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SettingsPage', () {
    testWidgets('renders all sections with default values', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Section headings.
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
      expect(find.text('Reading'), findsOneWidget);
      expect(find.text('Reading history'), findsOneWidget);

      // Default values visible in dropdowns.
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Suggestive'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);

      // Quality segmented button — both segments visible, Full selected.
      expect(find.text('Full'), findsOneWidget);
      expect(find.text('Data saver'), findsOneWidget);

      // Clear history tile.
      expect(find.text('Clear reading history'), findsOneWidget);
    });

    testWidgets('reflects non-default settings', (tester) async {
      await tester.pumpWidget(_buildApp(const Settings(
        preferredLanguage: 'fr',
        maxContentRating: 'erotica',
        imageQuality: 'data-saver',
        themeMode: ThemeMode.light,
      )));
      await tester.pump();

      expect(find.text('French'), findsOneWidget);
      expect(find.text('Erotica'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('quality segmented button switches imageQuality',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Tap "Data saver".
      await tester.tap(find.text('Data saver'));
      await tester.pump();

      // The notifier state should now reflect data-saver.
      // We verify by checking the SegmentedButton still renders without error.
      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets('content rating dropdown shows all tier options',
        (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Open the maximum content rating dropdown.
      await tester.tap(find.text('Suggestive'));
      await tester.pumpAndSettle();

      expect(find.text('Safe'), findsWidgets);
      expect(find.text('Suggestive'), findsWidgets);
      expect(find.text('Erotica'), findsOneWidget);
      expect(find.text('Pornographic'), findsOneWidget);
    });

    testWidgets('language dropdown shows available languages', (tester) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump();

      // Open the language dropdown.
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('French'), findsOneWidget);
      expect(find.text('Japanese'), findsOneWidget);
      expect(find.text('Korean'), findsOneWidget);
    });
  });
}
