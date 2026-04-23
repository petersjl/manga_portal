# Manga Portal — Agent Instructions

## Project Overview

A Flutter manga reading app for **Android and iOS** that fetches manga and chapter data from the [MangaDex API](https://api.mangadex.org/docs/). The app supports searching manga, maintaining a local library, reading chapters with multiple reading modes, and tracking reading progress locally with eventual sync to MangaDex when the user logs in.

**Design direction**: Dark mode first (light mode supported), Material 3, clean interface that emphasizes cover art.

---

## Tech Stack

| Concern           | Package                                    | Notes                                                                  |
| ----------------- | ------------------------------------------ | ---------------------------------------------------------------------- |
| State management  | `flutter_riverpod` + `riverpod_annotation` | `AsyncNotifier` for all API-backed state; provider overrides for tests |
| Navigation        | `go_router`                                | See routing conventions below                                          |
| HTTP              | `dio`                                      | Interceptors for User-Agent header, auth injection, rate-limit retry   |
| Image caching     | `cached_network_image`                     | Covers and reader pages                                                |
| Local storage     | `shared_preferences`                       | Reading progress, library, settings                                    |
| Secure storage    | `flutter_secure_storage`                   | OAuth tokens (Feature 8)                                               |
| Code generation   | `build_runner` + `riverpod_generator`      | For `@riverpod` annotations                                            |
| Widget tests      | `flutter_test` (built-in)                  |                                                                        |
| Integration tests | `integration_test` (built-in)              |                                                                        |

---

## Folder Structure

```
lib/
  main.dart                     # Entry point — runApp with ProviderScope
  app.dart                      # GoRouter config + MaterialApp.router
  models/
    manga.dart                  # Manga, MangaAttributes, CoverArt models
    chapter.dart                # Chapter, ChapterAttributes models
    chapter_pages.dart          # AtHomeServer model (baseUrl, hash, data, dataSaver)
  services/
    mangadex_api.dart           # All MangaDex API calls via Dio
    local_progress.dart         # SharedPreferences wrapper for reading progress
  providers/
    api_providers.dart          # Riverpod providers that wrap MangaDexApiService
    reader_provider.dart        # Current page index, quality mode, reading direction
    library_provider.dart       # Local library CRUD
    settings_provider.dart      # User preferences (quality, language, theme)
  pages/
    library_page.dart           # Grid of saved manga
    search_page.dart            # Search bar + results grid
    settings_page.dart          # Settings controls
    manga_detail_page.dart      # Cover, title, synopsis, chapter list
    reader_page.dart            # Paged or vertical scroll reader
  widgets/
    manga_card.dart             # Cover thumbnail + title card used in grids
    chapter_list_tile.dart      # Single chapter row in detail page
    reader_page_image.dart      # Single page image with MD@Home reporting

test/
  widget/                       # Unit/widget tests with mocked providers
integration_test/               # End-to-end tests running on device/emulator
```

---

## Routing Conventions (go_router)

All routes are defined in `lib/app.dart`. Named routes are used throughout — never construct path strings manually in UI code.

```
/                   → LibraryPage (shell — bottom nav tab 0)
/search             → SearchPage  (shell — bottom nav tab 1)
/settings           → SettingsPage (shell — bottom nav tab 2)
/manga/:mangaId     → MangaDetailPage
/reader/:chapterId  → ReaderPage
```

- `ShellRoute` wraps the three tab pages so the `NavigationBar` persists.
- Navigate with `context.go(...)` for tab switches, `context.push(...)` for detail/reader pages.
- Route parameters are passed as path params (`:id`), not query params, for shareable deep links.

---

## State Management Conventions (Riverpod)

- Use `@riverpod` code generation for all providers.
- Network data = `AsyncNotifier` or `FutureProvider`. Never store raw `Future`s in widgets.
- All `AsyncValue` states (loading / data / error) must be handled in the UI.
- Override providers in tests using `ProviderContainer` or `ProviderScope` with `overrides: [...]`.
- Service classes (`MangaDexApiService`, `LocalProgressService`) are plain Dart classes injected as providers; they are never instantiated directly in widgets.

```dart
// Pattern: provider wraps a service method
@riverpod
Future<AtHomeServer> atHomeServer(AtHomeServerRef ref, String chapterId) {
  return ref.watch(mangaDexApiServiceProvider).fetchAtHomeServer(chapterId);
}
```

---

## MangaDex API Conventions

### Base URL

`https://api.mangadex.org`

> **Stretch goal note**: A future companion project will allow users to host their own manga server implementing the same API contract as MangaDex. When that is added, the app will let users register one or more custom server URLs and merge results from all sources (MangaDex + self-hosted) into search and browse flows. To keep this path open:
>
> - The base URL for `MangaDexApiService` must be a constructor parameter, never hardcoded.
> - The service must not assume MangaDex-specific domain names anywhere outside of the `User-Agent` interceptor and the MD@Home reporting logic.
> - Do not implement multi-server support yet — just ensure no architectural decision closes the door on it.

### Required on every request

Every Dio request must include a `User-Agent` header set via a Dio interceptor:

```
User-Agent: manga-portal/1.0
```

Requests without a User-Agent are rejected by MangaDex.

### Do NOT send auth headers to image servers

Auth headers must never be sent to `uploads.mangadex.org` or any `*.mangadex.network` domain. Use a Dio interceptor that only injects the Authorization header for requests to `api.mangadex.org` and `auth.mangadex.org`.

### Rate limits

- Global: ~5 requests/second per IP
- `GET /at-home/server/:id`: 40 requests/minute — do not call this more than necessary
- On HTTP 429: back off and retry. Do NOT continue hammering the API.

### Fetching chapter images (at-home flow)

```
1. GET /at-home/server/:chapterId
   → { baseUrl, chapter: { hash, data[], dataSaver[] } }

2. Construct page URL:
   {baseUrl}/{quality}/{hash}/{filename}
   quality = "data" (full) or "data-saver" (compressed)

3. For each image loaded from a base URL that does NOT contain "mangadex.org":
   POST https://api.mangadex.network/report
   { url, success, bytes, duration, cached }
   cached = response had X-Cache header starting with "HIT"

4. On image load failure: re-call /at-home/server/:chapterId before retrying.
   The base URL is only valid for ~15 minutes; refresh on 403.
```

### Cover image URLs

```
https://uploads.mangadex.org/covers/{mangaId}/{coverFilename}.512.jpg  (512px thumbnail)
https://uploads.mangadex.org/covers/{mangaId}/{coverFilename}.256.jpg  (256px thumbnail)
https://uploads.mangadex.org/covers/{mangaId}/{coverFilename}          (full size)
```

Get `coverFilename` from the manga's `cover_art` relationship. Use reference expansion (`?includes[]=cover_art`) to avoid a second API call.

### Reference expansion

Append `includes[]=cover_art` (or other relationship types) to avoid extra roundtrips:

```
GET /manga/:id?includes[]=cover_art
```

The relationship data is embedded in the response under `data.relationships`.

### Pagination

- `offset` + `limit` in query params. Max `offset + limit ≤ 10,000`.
- Max `limit = 100` for most endpoints; `500` for feed endpoints.
- Always paginate: never assume all results fit in one page.

### Authentication (Feature 8 — deferred)

MangaDex uses OAuth2. **Public clients (for multi-user apps) are not yet available** as of April 2026. Until they are:

- Personal clients (password flow) only work for the client owner's account.
- Design the auth layer to be a plugin that can be swapped in; the app works fully without it.
- Store tokens in `flutter_secure_storage`.
- Sync chapter-read status via `POST /chapter/{id}/read` after auth is available.

---

## Reading Progress

Reading progress is stored locally in `SharedPreferences` first, then synced to MangaDex when authenticated.

**Local storage keys** (subject to refinement):

- `progress_{mangaId}_chapter` → chapter ID string
- `progress_{mangaId}_page` → integer page index

**Sync behavior**:

- On chapter completion: call `POST /chapter/:chapterId/read` if authenticated.
- On failure: store failed syncs in a local retry queue. Retry at the end of the next chapter completion.
- The app must work fully without an internet connection for already-fetched data.

**Storage scalability note**: `LocalProgressService` must sit behind a clean interface so it can be swapped for a `drift`/`sqflite` implementation later without touching providers or UI. SharedPreferences is sufficient now but will not scale to full reading history. Do not let SharedPreferences calls leak into the provider layer — always go through `LocalProgressService`.

---

## Reader Behavior Conventions

### Page preloading

Pages must be preloaded based on proximity to the current page so the user never sees a loading spinner during normal reading at typical network speeds.

- Use `CachedNetworkImage` throughout; its cache handles repeated views automatically.
- Eagerly call `precacheImage` for at least 3 pages ahead of the current page index and 1 page behind, in addition to whatever Flutter renders naturally from the scroll view.
- For `ListView` (vertical/webtoon mode): set a generous `cacheExtent` so off-screen pages are rendered and cached before the user scrolls to them.

### Chapter boundary navigation

When the user swipes or scrolls past the last page of a chapter, show a **chapter transition page** — a full-screen interstitial within the same scroll/swipe sequence that displays the current and next chapter numbers. Continuing past it loads the next chapter in place without navigating to a new route. Swiping back from the first page shows a transition page for the previous chapter.

- `ReaderPage` must receive the full sorted chapter list for the manga so it can determine next/prev chapters without extra API calls.
- **Next chapter auto-selection** (when the next chapter number has multiple versions):
  1. One version in the preferred language → use it automatically.
  2. Multiple versions in the preferred language → prefer the same scanlation group as the current chapter; if unavailable, pick one at random (user can return to chapter select to change).
  3. No version in the preferred language → show a **language unavailability page** instead of the transition page: a full-screen message explaining the chapter is not available in the preferred language, with a button to return to chapter select.
- The transition and unavailability pages are part of the `ReaderPage` scroll/swipe sequence — they are not separate routes.

---

## Testing Conventions

### Widget tests (`test/widget/`)

- Located in `test/widget/`.
- Mock `MangaDexApiService` using Riverpod provider overrides — never mock `http` directly.
- Every feature must ship at least one widget test covering the primary happy path and basic error/loading states.
- Use `pumpWidget` with a `ProviderScope` + `overrides`.

```dart
testWidgets('ReaderPage shows first page image', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        atHomeServerProvider.overrideWith((ref, chapterId) async => fakeAtHomeServer),
      ],
      child: const MaterialApp(home: ReaderPage(chapterId: 'test-id')),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(CachedNetworkImage), findsWidgets);
});
```

### Integration tests (`integration_test/`)

- Located in `integration_test/`.
- Use a mocked Dio interceptor (injected via provider) to intercept HTTP and return fixture JSON — no live API calls in CI.
- Each integration test covers a full user flow: tap action → navigate → verify result.
- Every feature must ship at least one integration test for its primary user flow.

### Test file naming

- `test/widget/reader_page_test.dart` mirrors `lib/pages/reader_page.dart`.
- `integration_test/reader_flow_test.dart` for end-to-end reader flow.

---

## Code Style

- Follow `flutter_lints` (already in `analysis_options.yaml`). Fix all warnings before committing.
- `const` constructors everywhere possible.
- All model classes use `fromJson` factory constructors and `toJson` methods.
- No `dynamic` types in model or service layers.
- Chapter numbers from the MangaDex API must be stored as `String?` (nullable) — they can be `null` (oneshots), decimal strings like `"1.5"` (bonus chapters), or absent. Never parse them as a numeric type.
- Use `freezed` if models become complex; for now plain Dart classes with `fromJson`/`toJson` are sufficient.
- Error messages shown in UI should be human-readable, not raw exception strings.
- File names: `snake_case.dart`. Class names: `PascalCase`. Variables/methods: `camelCase`.

---

## Known Issues in Existing Code

- `main.dart` `AnimatedSwitcher` uses `Duration(microseconds: 1000)` (1ms). Should be `Duration(milliseconds: 300)`.
- `test/widget_test.dart` contains the default counter test which will fail — replace it with a smoke test for `MangaPortal` rendering.
