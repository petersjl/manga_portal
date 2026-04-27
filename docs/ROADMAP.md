# Manga Portal — Feature Roadmap

Features are implemented one at a time in order. Each feature ships with accompanying tests before moving on. Do not begin a feature until all tests from the previous feature pass.

---

## Feature 0 — Project Infrastructure ✅

**Goal**: Establish the foundation every subsequent feature builds on.

### Tasks

- [x] Add packages to `pubspec.yaml`:
  - `flutter_riverpod`, `riverpod_annotation` — state management
  - `go_router` — navigation
  - `dio` — HTTP client
  - `cached_network_image` — image caching
  - `shared_preferences` — local progress + library + settings storage
  - `flutter_secure_storage` — auth token storage (used in Deferred Feature 1)
  - `build_runner`, `riverpod_generator` — code generation (dev)
- [x] Run `flutter pub get`
- [x] Create `lib/app.dart`:
  - Define all named `GoRouter` routes
  - Wrap with `ProviderScope`
  - `ShellRoute` for the 3 bottom-nav tabs
- [x] Update `lib/main.dart`:
  - Replace `MaterialApp` with `MaterialApp.router` using the router from `app.dart`
  - Wrap root with `ProviderScope`
  - Apply dark-first Material 3 theme (dark as `themeMode` default, both `theme` and `darkTheme` defined)
  - Fix `AnimatedSwitcher` duration bug: `microseconds: 1000` → `milliseconds: 300`
- [x] Replace `test/widget_test.dart` default counter test with a smoke test that verifies `MangaPortal` renders without throwing

### Tests

- Widget test: `test/widget/app_test.dart` — smoke test that `MangaPortal` renders and bottom nav is present

---

## Feature 1 — Steel Thread: Hardcoded Reader ✅

**Goal**: Navigate from the app to a working chapter reader using a hardcoded manga and chapter ID. Proves the full image-fetching pipeline works end-to-end before building any discovery features.

### Context

The at-home server flow:

1. `GET /at-home/server/:chapterId` → `{ baseUrl, chapter: { hash, data[], dataSaver[] } }`
2. Construct page URL: `{baseUrl}/data/{hash}/{filename}`
3. For non-`mangadex.org` base URLs, report each image fetch result to `https://api.mangadex.network/report`
4. On 403: re-fetch the at-home server endpoint to get a fresh base URL

### Tasks

- [x] Create `lib/models/chapter_pages.dart` — `AtHomeServer` model with `fromJson`
- [x] Create `lib/services/mangadex_api.dart` — `MangaDexApiService`:
  - Dio instance with `User-Agent: manga-portal/1.0` interceptor
  - `Future<AtHomeServer> fetchAtHomeServer(String chapterId)`
- [x] Create `lib/providers/api_providers.dart`:
  - `mangaDexApiServiceProvider` — provides `MangaDexApiService`
  - `atHomeServerProvider(chapterId)` — `FutureProvider` wrapping `fetchAtHomeServer`
- [x] Create `lib/widgets/reader_page_image.dart`:
  - `Image` widget backed by `CachedNetworkImageProvider` for a single page
  - Reports success/failure to `api.mangadex.network/report` when base URL is not from `mangadex.org`
  - On failure: notifies parent to refresh the at-home server URL
- [x] Create `lib/pages/reader_page.dart` — `ReaderPage(chapterId: String)`:
  - Watches `atHomeServerProvider`
  - Builds `PageView` of `ReaderPageImage` widgets (horizontal paged, left-to-right)
  - Shows `CircularProgressIndicator` while loading
  - Shows human-readable error + retry button on failure
  - Preloads adjacent pages: immediate window (3 ahead, 1 behind) fired concurrently; background sequential preload for the entire chapter in distance order from current page
- [x] Add a temporary "Open Reader" button to `LibraryPage` with a hardcoded chapter ID pointing to a known-good MangaDex chapter

### Tests

- [x] Widget test: `test/widget/reader_page_test.dart`
  - Happy path: mock `atHomeServerProvider`, verify `PageView` and page images render
  - Loading state: verify `CircularProgressIndicator` shown while provider is loading
  - Error state: verify error message + retry button shown when provider throws
- [x] Integration test: `integration_test/reader_flow_test.dart`
  - Tap "Open Reader" button → `ReaderPage` navigates and loads pages (mocked HTTP)

---

## Feature 2 — Manga Detail Page & Real Chapter Navigation ✅

**Goal**: Replace the hardcoded chapter ID with real manga browsing. A detail page shows manga info and its chapter list; tapping a chapter opens the reader.

### Tasks

- [x] Create `lib/models/manga.dart` — `Manga`, `MangaAttributes`, `CoverArt` with `fromJson`
- [x] Create `lib/models/chapter.dart` — `Chapter`, `ChapterAttributes` with `fromJson`
  - `chapterNumber` must be `String?` — can be `null` (oneshots), `"1.5"` (bonus chapters), or absent. Never parse as a number.
  - Store scanlation group ID and name from the chapter's `scanlation_group` relationship
- [x] Add to `MangaDexApiService`:
  - `Future<Manga> fetchManga(String mangaId)` — `GET /manga/:id?includes[]=cover_art`
  - `Future<List<Chapter>> fetchChapterFeed(String mangaId, {int offset = 0})` — `GET /manga/:id/feed` with **no language filter** (fetch all languages so the UI can show availability), `includes[]=scanlation_group`, sorted by chapter ascending, up to 500 per page
- [x] Add to `api_providers.dart`:
  - `mangaProvider(mangaId)` — `FutureProvider`
  - `chapterFeedProvider(mangaId)` — paginated `FutureProvider`; fetches all languages (handles internal pagination) and groups chapters by chapter number client-side
- [x] Create `lib/widgets/manga_card.dart` — cover image + title, used in both detail and search
- [x] Create `lib/widgets/chapter_list_tile.dart` — one tile per unique chapter number:
  - Chapters are grouped by `chapterNumber` (`String?`); each tile represents one chapter number across all its available versions
  - **One group in preferred language**: shows chapter number, title, group name, date; tap opens reader directly
  - **Multiple groups in preferred language**: shows chapter number and date; tap expands an inline drawer listing all available scanlation groups to choose from
  - **Not available in preferred language** (other languages only): shown in a subdued style with a note (e.g. "Not available in English"); non-interactive
- [x] Create `lib/pages/manga_detail_page.dart`:
  - 512px cover image, title, description, chapter list sorted by chapter number descending (newest first)
  - Renders one `ChapterListTile` per unique chapter number using grouped data from `chapterFeedProvider`
  - Tap single-group chapter → `context.push('/reader/:chapterId')`
  - Tap multi-group chapter → expand inline group picker drawer, then navigate on selection
- [x] Register `/manga/:mangaId` route in `app.dart`
- [x] Update `LibraryPage` stub button to navigate to a hardcoded manga detail page instead of directly to the reader
- [x] Remove hardcoded "Open Reader" button (replaced with "Open Manga Detail (test)")
- [x] Create `lib/providers/settings_provider.dart` — `Settings` with `preferredLanguage` and `contentRating` defaults (needed for chapter language filtering)

### Tests

- [x] Widget test: `test/widget/manga_detail_page_test.dart`
  - Renders manga title, description, and chapter list from mocked providers
  - Shows loading state
  - Shows manga error + retry button
  - Shows chapters error section independently
  - Unavailable-language chapters shown subdued
  - Multi-group chapter expands to show group list
- [x] Integration test: `integration_test/reader_flow_test.dart` (updated)
  - Navigate to detail page → chapter list appears → tap chapter → reader opens

---

## Feature 3 — Search Page ✅

**Goal**: Users can search for any manga by title and navigate to its detail page.

### Tasks

- [x] Add to `MangaDexApiService`:
  - `Future<List<Manga>> searchManga(String query, {int offset = 0, List<String> contentRating = const ['safe', 'suggestive']})` — `GET /manga?title=...&includes[]=cover_art&limit=20` with `contentRating[]` params
- [x] Add to `api_providers.dart`:
  - `mangaSearchProvider(query)` — `AsyncNotifier` with debounce, supports pagination; reads `contentRating` from `settingsProvider`
- [x] Implement `lib/pages/search_page.dart`:
  - Search `TextField` at top
  - Debounced search (300ms) on text change
  - Scrollable grid of `MangaCard` widgets
  - Loading indicator, empty state, error state
  - Tap card → `context.push('/manga/:mangaId')`
- [x] Remove `Placeholder` from `SearchPage`

### Tests

- Widget test: `test/widget/search_page_test.dart`
  - Search results render from mocked provider
  - Empty query shows empty state
  - Error shows human-readable message
- Integration test: `integration_test/search_flow_test.dart`
  - Type query → results appear → tap card → detail page loads

_All tasks and tests complete. Verified on emulator: real MangaDex search returns results, covers load, tapping a card navigates to the detail page._

---

## Feature 4 — Reading Progress & Reader Polish ✅

**Goal**: The reader remembers where you left off per chapter. Quality modes and reading direction are configurable. MangaDex@Home reporting is fully compliant.

### Tasks

- [x] Create `lib/services/local_progress.dart` — `LocalProgressService`:
  - `saveProgress(mangaId, chapterId, pageIndex)`
  - `getProgress(mangaId)` → `{chapterId, pageIndex}`
  - Uses `SharedPreferences` keys: `progress_{mangaId}_chapter`, `progress_{mangaId}_page`
- [x] Create `lib/providers/reader_provider.dart`:
  - `readerModeProvider` — paged vs vertical scroll per manga (persisted locally)
  - `imageQualityProvider` — data vs data-saver (from settings)
- [x] Update `ReaderPage`:
  - Now accepts `mangaId` and the full sorted chapter list in addition to `chapterId`, so it can determine next/prev chapters without extra API calls
  - On open: restore saved page index for this chapter
  - On page change: save progress via `LocalProgressService`; call `precacheImage` for 3 pages ahead and 1 behind at all times
  - On reaching the last page: show a **chapter transition page** (inline interstitial in the scroll sequence) displaying current and next chapter; swiping/scrolling past it loads the next chapter using the rules below
  - On swiping back from the first page: show a chapter transition page for the previous chapter
  - **Next/prev chapter auto-selection**:
    1. One group in preferred language → select automatically
    2. Multiple groups in preferred language → prefer same scanlation group as current chapter; otherwise pick at random
    3. Chapter number exists but not in preferred language → show **language unavailability page** (full-screen message with button to return to chapter select)
  - On chapter completion (swiping past the transition page): enqueue `POST /chapter/:id/read` for when auth is added
  - Support image quality toggle (data vs data-saver) from `imageQualityProvider`
- [x] Fully implement `ReaderPageImage` MD@Home reporting:
  - Track `bytes` and `duration` for each image load
  - `cached` = response `X-Cache` header starts with `"HIT"`
  - POST to `https://api.mangadex.network/report` for non-`mangadex.org` base URLs
  - On failure: signal parent to re-fetch at-home server before retry

### Tests

- [x] Widget test: `test/widget/reader_progress_test.dart`
  - Progress is saved on page change
  - Reader opens to saved page index
  - Swiping past the last page shows the chapter transition page
  - Swiping back from the first page shows the previous chapter transition page
  - Next chapter not in preferred language shows the language unavailability page
- [x] Integration test: `integration_test/reader_progress_flow_test.dart`
  - Open chapter at page 3, close, reopen — starts at page 3
  - Swipe past last page → transition page shown → swipe again → next chapter loads
  - Chapter state indicators ("Start" / "Continue" / "Read") reflect progress correctly
  - "Continue" button on detail page opens reader at the saved page
  - Opening a chapter without paging does not overwrite in-progress state
  - Clearing reading history from Settings resets all chapter progress

### Extras

- **`SettingsPage` — Clear reading history**: Added a "Clear reading history" action to the Settings page. Tapping it shows a confirmation dialog; on confirm, all `SharedPreferences` progress keys are cleared and a snackbar confirms the action.
- **Chapter state indicators on detail page**: `MangaDetailPage` displays per-chapter status badges — "Start Ch. X", "Continue Ch. X" (with saved page shown), and "Read" — reflecting the current `LocalProgressService` state. The primary action button at the top of the page mirrors the most recent in-progress or next unread chapter.
- **`_hasUserPaged` guard**: Progress is only written to `LocalProgressService` after the user has actively swiped at least once in the reader session. Opening a chapter and immediately closing it does not overwrite a previously saved page index.
- **Integration test infrastructure fixes**: Three bugs in the integration test suite were diagnosed and fixed:
  - `reader_flow_test.dart` page count assertion updated from `"1 / 2"` to `"1 / 5"` to match the mock server's 5-page chapters.
  - `goRouter` singleton navigation state leak between `testWidgets` calls fixed by adding `goRouter.go('/') + pumpAndSettle()` at the start of each test's navigation helper.
  - `SharedPreferences` state leak between `testWidgets` calls fixed by adding a `setUp(() async { prefs.clear() })` block.

---

## Feature 5 — Library Page ✅

**Goal**: Users can save manga to a local library and return to them quickly.

### Tasks

- [x] Create `lib/providers/library_provider.dart` — `LibraryNotifier` (`AsyncNotifier`):
  - Stores list of manga IDs + cached title + cached cover URL in `SharedPreferences`
  - `addManga(Manga)`, `removeManga(mangaId)`, `isInLibrary(mangaId)`
  - On `app.dart` startup: pre-populate from saved IDs
- [x] Update `MangaDetailPage`:
  - Add "Add to Library" / "Remove from Library" toggle button
- [x] Implement `lib/pages/library_page.dart`:
  - Grid of `MangaCard` widgets from library provider
  - Empty state when no manga saved
  - Tap card → detail page
  - Remove `Placeholder`

### Tests

- [x] Widget test: `test/widget/library_page_test.dart`
  - Library grid renders saved manga
  - Empty state shows when no manga saved
- [x] Integration test: `integration_test/library_flow_test.dart`
  - Add manga from detail page → appears in library → tap → navigates to detail

### Extras

- **Persistent top bar**: The detail page uses a standard `AppBar` (always pinned) with the back button and bookmark icon clearly visible above the cover art, eliminating the issue of buttons being hard to see when overlaid on cover images.
- **Frosted-glass title strip**: The manga title is rendered at the bottom of the cover image on a `BackdropFilter`-blurred semi-transparent strip, keeping it legible regardless of the artwork behind it.
- **`clearSnackBars()` pattern**: Every snackbar is shown with `..clearSnackBars()..showSnackBar(...)` to prevent queue conflicts when adding and removing in quick succession.
- **Integration test runner fix**: Added per-file sequential execution to `tool/run_integration_tests.dart` and `tool/run_all_tests.dart` to prevent parallel APK installs from killing in-progress test sessions on the shared device.

---

## Feature 6 — Settings Page ✅

**Goal**: Users can configure language, image quality, and theme.

### Tasks

- [x] Create `lib/providers/settings_provider.dart` — `SettingsNotifier` (sync `Notifier<Settings>`):
  - `preferredLanguage` (default: `'en'`) — stored in `SharedPreferences`
  - `maxContentRating` (default: `'suggestive'`) — stored in `SharedPreferences`; `contentRating` computed getter returns all tiers at or below the max
  - `imageQuality` (`data` or `data-saver`) — stored in `SharedPreferences`
  - `themeMode` (`system` / `light` / `dark`) — stored in `SharedPreferences`
- [x] Update `main.dart` to read `themeMode` from `settingsNotifierProvider`
- [x] API calls already use `settings.contentRating` (computed getter) — no changes needed
- [x] Implement `lib/pages/settings_page.dart`:
  - Theme dropdown (System / Light / Dark)
  - Language dropdown (13 languages)
  - Max content rating dropdown (Safe / Suggestive / Erotica / Pornographic)
  - Image quality `SegmentedButton` (Full / Data saver)
  - "Clear reading history" tile with confirmation dialog
  - Remove `Placeholder`

### Tests

- [x] Widget test: `test/widget/settings_page_test.dart` (5 tests)
  - Settings render with correct initial values
  - Reflects non-default settings
  - Quality segmented button switches imageQuality
  - Content rating dropdown shows all tier options
  - Language dropdown shows available languages
- [x] Integration test: `integration_test/settings_flow_test.dart` (3 tests)
  - Settings page renders all sections
  - Change quality setting → opens reader → data-saver URLs confirmed in mock server logs
  - Language setting persists across navigation

### Extras

- **Max content rating as a cascade**: Rather than a multi-select checklist, content rating uses a single "maximum allowed" dropdown. Selecting "Suggestive" automatically includes Safe + Suggestive. The `contentRating` getter on `Settings` computes the list from `_ratingOrder`, keeping all API call sites unchanged.
- **Sync notifier with async init**: `SettingsNotifier` is a sync `Notifier<Settings>` so all existing `ref.watch(settingsNotifierProvider)` call sites continue working without destructuring. `build()` returns defaults synchronously and `_loadFromPrefs()` updates state asynchronously on first build.

---

## Feature 7 — Vertical Scroll (Webtoon) Mode ✅

**Goal**: Support vertical continuous scroll in addition to horizontal paged reading. Users set a preferred mode per series (stored locally).

### Tasks

- [x] Add per-manga reading direction to `LocalProgressService`:
  - `saveReadingMode(mangaId, ReadingMode mode)`
  - `getReadingMode(mangaId)` → `ReadingMode` (defaults to paged)
- [x] Update `ReaderPage`:
  - Check `readingModeProvider(mangaId)` on load
  - Paged mode: `PageView` (existing)
  - Vertical mode: `ListView` of `ReaderPageImage` widgets; track visible page for progress saving
- [x] Add reading mode toggle button in reader app bar
- [x] Add reading mode selector on `MangaDetailPage` (sets default for that series)

### Tests

- Widget test: `test/widget/reader_modes_test.dart`
  - Paged mode renders `PageView`
  - Vertical mode renders `ListView`
  - Mode toggle switches between them
- Integration test: `integration_test/reader_modes_flow_test.dart`
  - Set vertical mode on detail page → open reader → scrolls vertically

### Extras

- `ReadingModeNotifier` is a sync `Notifier<String>` that returns `'paged'` immediately and asynchronously loads the persisted preference in `build()` — no loading spinner for mode state.
- Scroll mode tracks reading progress via a `ScrollController` listener, estimating the current page from scroll fraction and marking the chapter read when 95% scrolled.
- A 70%-screen-height footer slot in scroll mode acts as the chapter transition interstitial, keeping the scroll-to-next-chapter flow consistent with paged mode.
- Storage key `reading_mode_{mangaId}` is intentionally excluded from `clearAllProgress()` — reading mode is a preference, not history.

---

## Feature 8 — Reader Info Bars & Settings Drawer ✅

**Goal**: Replace the always-visible static reader chrome with auto-hiding top and bottom info bars, and move reading mode configuration into a bottom drawer accessible from the reader.

### Tasks

- [x] Add visibility state to `ReaderPage` (bool `_barsVisible`, toggled on tap anywhere outside the bars)
- [x] Top bar (animated slide in/out from top):
  - Back button (pops the route)
  - Title: `"{chapter number}: {chapter name}"` — falls back to `"Chapter {number}"` when no title
  - Settings cog icon that opens the reader settings bottom sheet
- [x] Bottom bar (animated slide in/out from bottom):
  - "Prev" button — same behaviour as swiping past the first page (shows previous-chapter transition or does nothing on first chapter)
  - Centered page counter: `"{currentPage}/{totalPages}"`
  - "Next" button — same behaviour as swiping past the last page (shows next-chapter transition)
- [x] Auto-hide bars:
  - Paged mode: hide bars on any `PageView` page change
  - Scroll mode: hide bars when the user starts scrolling vertically
- [x] Tap-to-toggle: tapping anywhere in the reader that is NOT one of the bars toggles visibility
- [x] Reader settings bottom sheet (opened from the cog):
  - Reading mode selector — a `SegmentedButton` supporting `n` items (currently: Paged / Vertical); replaces the mode selector on `MangaDetailPage` and the toggle button in the AppBar
  - The `MangaDetailPage` reading mode selector and AppBar toggle button should be **removed** once the bottom sheet is in place
- [x] Bars and bottom sheet use `AnimatedSlide` + `AnimatedOpacity` (or equivalent) for smooth show/hide transitions

### Tests

- [x] Widget test: `test/widget/reader_modes_test.dart`
  - Bars are hidden on initial render
  - Tapping the reader body shows the bars
  - Tapping again hides the bars
  - Prev/Next buttons trigger chapter navigation callbacks
  - Settings cog opens the bottom sheet with the reading mode selector
- [x] Integration test: `integration_test/reader_modes_flow_test.dart`
  - Open reader → bars not visible → tap screen → bars appear → tap cog → bottom sheet with mode selector shown
  - Switch reading mode in bottom sheet → ListView / PageView rendered accordingly

### Extras

- Added three in-reader reading modes: `L->R`, `R->L`, and `Vertical/Scroll` in the reader settings sheet, replacing the old two-option selector and preserving per-series preference.
- Implemented full R->L page ordering (page 1 at far right, last page at far left), with transition-edge behavior and bottom bar button placement matched to direction (`Next` on left only in R->L).
- Direction switching now preserves the current logical page number when toggling between `L->R` and `R->L`.
- Reader settings control was resized to fit sheet width reliably on smaller screens so mode buttons no longer overflow.

---

## Feature 9 — Local Database Foundation 🚧 (In Progress)

**Goal**: Introduce a structured local database layer before offline downloads so download metadata, queue state, and file mapping are robust and queryable.

### Why this comes first

- Downloaded chapters need durable metadata: status (`queued/downloading/completed/failed`), progress, errors, file paths, and integrity checks.
- `SharedPreferences` is fine for small key/value settings but becomes brittle for queue orchestration and large offline libraries.
- A database-first foundation reduces rework when implementing pause/resume, cleanup, and "downloaded only" filtering.

### Tasks

- [ ] Add DB package(s) in `pubspec.yaml` (`drift` + `sqlite3_flutter_libs` + build tooling) and run codegen.
- [ ] Create local DB module (schema + DAOs) for:
  - manga table (id, title, cover url cache)
  - chapters table (id, mangaId, chapter number/title/language/group)
  - download jobs table (chapterId, status, progress, bytes, error, timestamps)
  - downloaded pages table (chapterId, page index, local file path, checksum/size)
- [ ] Add a storage abstraction service layer so providers/UI do not import DB directly.
- [ ] Migrate existing progress/library/settings persistence behind service interfaces (keep behavior unchanged).
- [ ] Add migration/versioning strategy for future schema changes.

### Tests

- [ ] Unit tests for DAO CRUD and migrations.
- [ ] Widget smoke tests to ensure existing library/progress/settings behavior remains unchanged after backend swap.

---

## Feature 10 — Offline Chapter Downloads

**Goal**: Let users download selected chapters to local storage and read them fully offline with zero network calls during reading.

### Tasks

- [ ] Add download UI on `MangaDetailPage` and/or chapter rows:
  - queue/download/remove chapter
  - per-chapter status chip (Not downloaded / Queued / Downloading / Downloaded / Failed)
- [ ] Implement `DownloadService`:
  - fetch chapter pages once and save image files under app documents storage
  - write all metadata/state to DB tables
  - bounded concurrency and retry/backoff on transient failures
  - mark completed only when all pages are present and validated
- [ ] Reader offline-first resolution:
  - if chapter is downloaded, load local files only
  - do not call `at-home/server` or image network endpoints for downloaded chapters
  - fallback to online flow only when chapter is not downloaded
- [ ] Add storage management:
  - remove one chapter download
  - remove all downloads for a manga
  - compute and display download size used
- [ ] Add optional "Downloaded only" filter for library/detail chapter lists.

### Tests

- [ ] Unit tests for download state machine and retry logic.
- [ ] Widget tests for chapter download status rendering.
- [ ] Integration test:
  - download chapter online
  - relaunch / disable network
  - open downloaded chapter and read pages with no network requests

---

## Stretch Goal — Self-Hosted Server Support (Future, No Implementation Yet)

**Goal**: Allow users to point the app at one or more self-hosted manga servers that implement the same API contract as MangaDex. Searches and browse flows would aggregate results from MangaDex and any configured custom servers.

**Companion project**: A separate server project will expose the necessary MangaDex-compatible API endpoints so the app requires no special handling per source — a self-hosted server is treated identically to MangaDex.

**Design constraints to respect now** (so this does not require a rewrite later):

- `MangaDexApiService` accepts its base URL as a constructor parameter — never hardcode `https://api.mangadex.org` inside method bodies.
- Service logic must not assume MangaDex-specific domains except in the `User-Agent` interceptor and the MD@Home image-reporting logic (which only applies to `mangadex.network` base URLs anyway).
- When this feature is eventually implemented, a `SettingsPage` field will let users add/remove custom server URLs, and the provider layer will fan out requests and merge results.

**Do not implement** any multi-server UI, provider fan-out, or settings until the companion server project exists and the feature is formally prioritized.

---

## Stretch Goal — Dual-Page Landscape Mode (Future)

**Goal**: In landscape orientation, show two manga pages side by side (book spread format), useful for two-page art spreads.

**Design constraint to respect now**: Keep the page-rendering logic (`ReaderPageImage`) decoupled from the layout. The reader should compose pages into a layout container rather than baking layout assumptions into the image widget, so a two-column `Row` layout can be added without restructuring.

---

## Stretch Goal — Local Database Migration (Future)

Status note: Superseded by Feature 9 detour above. Keep this section only as historical context.

**Goal**: Move from `SharedPreferences` to a structured local database (`drift` or `sqflite`) to support full reading history, download queues, and richer library management.

**Design constraint to respect now**: All storage access goes through `LocalProgressService` and equivalent service classes — never call `SharedPreferences` directly from providers or UI. This makes the migration a service-layer swap with no upstream changes required.

---

## Deferred Feature 1 — MangaDex Authentication

**Status**: Blocked — MangaDex public OAuth clients are not available as of April 2026. Personal clients only work for the owning account.

**Goal**: Allow users to log in to MangaDex to sync reading history and library.

### When to implement

Revisit once MangaDex announces public client availability in `#dev-talk-api` on their [Discord](https://discord.gg/mangadex).

### Planned Tasks

- [ ] Register an OAuth2 public client with MangaDex
- [ ] Implement `authorization_code` flow opening `https://auth.mangadex.org` in system browser
- [ ] Handle redirect callback back into the app
- [ ] Store access + refresh tokens in `flutter_secure_storage`
- [ ] Dio interceptor: inject `Authorization: Bearer <token>` for `api.mangadex.org` only — never for image domains
- [ ] On chapter completion: `POST /chapter/:id/read`
- [ ] Retry queue: failed sync attempts stored in `SharedPreferences`; retried at end of each subsequent chapter completion
- [ ] Library sync: fetch MangaDex follows/MDList and merge with local library

### Tests

- Widget test: unauthenticated state shows login button; authenticated state shows username
- Integration test: token stored after login; retry queue retried on next chapter complete

---

## Testing Checklist (per feature)

Before marking a feature complete, verify:

- [ ] At least one widget test covering the primary happy path
- [ ] At least one widget test covering loading and error states
- [ ] At least one integration test covering the primary user flow
- [ ] All tests pass (`flutter test test/widget/` and `flutter test integration_test/`)
- [ ] `flutter analyze` reports no errors or warnings
