import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:manga_portal/main.dart';

void main() {
  testWidgets('MangaPortal renders without throwing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MangaPortal()));
    // Let the router settle on the initial route.
    await tester.pumpAndSettle();
    // The app itself should be present in the widget tree.
    expect(find.byType(MangaPortal), findsOneWidget);
  });
}
