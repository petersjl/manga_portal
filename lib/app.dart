import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/library_page.dart';
import 'pages/search_page.dart';
import 'pages/settings_page.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'library',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LibraryPage(),
          ),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchPage(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsPage(),
          ),
        ),
      ],
    ),
    // Detail and reader routes sit outside the shell so the nav bar is hidden.
    GoRoute(
      path: '/manga/:mangaId',
      name: 'mangaDetail',
      builder: (context, state) {
        // MangaDetailPage will be created in Feature 2.
        throw UnimplementedError('MangaDetailPage not yet implemented');
      },
    ),
    GoRoute(
      path: '/reader/:chapterId',
      name: 'reader',
      builder: (context, state) {
        // ReaderPage will be created in Feature 1.
        throw UnimplementedError('ReaderPage not yet implemented');
      },
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/settings')) return 2;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/search');
      case 2:
        context.go('/settings');
    }
  }
}
