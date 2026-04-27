// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mangaDexApiServiceHash() =>
    r'6a46ffbab2dc10e14270fb96cc8d5f83076d5063';

/// See also [mangaDexApiService].
@ProviderFor(mangaDexApiService)
final mangaDexApiServiceProvider =
    AutoDisposeProvider<MangaDexApiService>.internal(
  mangaDexApiService,
  name: r'mangaDexApiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mangaDexApiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MangaDexApiServiceRef = AutoDisposeProviderRef<MangaDexApiService>;
String _$appDatabaseHash() => r'4db1c5efe1a73afafa926c6e91d12e49a68b1abc';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$storageMigrationHash() => r'4af1af946ae97ca0e3c41f71360d9bd4f12491b9';

/// See also [storageMigration].
@ProviderFor(storageMigration)
final storageMigrationProvider = AutoDisposeFutureProvider<void>.internal(
  storageMigration,
  name: r'storageMigrationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageMigrationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageMigrationRef = AutoDisposeFutureProviderRef<void>;
String _$localProgressServiceHash() =>
    r'046b04f3ea6b625f25d2c3a42a5e471ab86daa2f';

/// See also [localProgressService].
@ProviderFor(localProgressService)
final localProgressServiceProvider =
    AutoDisposeFutureProvider<LocalProgressService>.internal(
  localProgressService,
  name: r'localProgressServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localProgressServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalProgressServiceRef
    = AutoDisposeFutureProviderRef<LocalProgressService>;
String _$atHomeServerHash() => r'90bb36633d7153db3f323e600977eb8f754f4e39';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [atHomeServer].
@ProviderFor(atHomeServer)
const atHomeServerProvider = AtHomeServerFamily();

/// See also [atHomeServer].
class AtHomeServerFamily extends Family<AsyncValue<AtHomeServer>> {
  /// See also [atHomeServer].
  const AtHomeServerFamily();

  /// See also [atHomeServer].
  AtHomeServerProvider call(
    String chapterId,
  ) {
    return AtHomeServerProvider(
      chapterId,
    );
  }

  @override
  AtHomeServerProvider getProviderOverride(
    covariant AtHomeServerProvider provider,
  ) {
    return call(
      provider.chapterId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'atHomeServerProvider';
}

/// See also [atHomeServer].
class AtHomeServerProvider extends AutoDisposeFutureProvider<AtHomeServer> {
  /// See also [atHomeServer].
  AtHomeServerProvider(
    String chapterId,
  ) : this._internal(
          (ref) => atHomeServer(
            ref as AtHomeServerRef,
            chapterId,
          ),
          from: atHomeServerProvider,
          name: r'atHomeServerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$atHomeServerHash,
          dependencies: AtHomeServerFamily._dependencies,
          allTransitiveDependencies:
              AtHomeServerFamily._allTransitiveDependencies,
          chapterId: chapterId,
        );

  AtHomeServerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.chapterId,
  }) : super.internal();

  final String chapterId;

  @override
  Override overrideWith(
    FutureOr<AtHomeServer> Function(AtHomeServerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AtHomeServerProvider._internal(
        (ref) => create(ref as AtHomeServerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        chapterId: chapterId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AtHomeServer> createElement() {
    return _AtHomeServerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AtHomeServerProvider && other.chapterId == chapterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, chapterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AtHomeServerRef on AutoDisposeFutureProviderRef<AtHomeServer> {
  /// The parameter `chapterId` of this provider.
  String get chapterId;
}

class _AtHomeServerProviderElement
    extends AutoDisposeFutureProviderElement<AtHomeServer>
    with AtHomeServerRef {
  _AtHomeServerProviderElement(super.provider);

  @override
  String get chapterId => (origin as AtHomeServerProvider).chapterId;
}

String _$mangaHash() => r'954071186760d74354c4d82bb5bec7f79d5ad721';

/// See also [manga].
@ProviderFor(manga)
const mangaProvider = MangaFamily();

/// See also [manga].
class MangaFamily extends Family<AsyncValue<Manga>> {
  /// See also [manga].
  const MangaFamily();

  /// See also [manga].
  MangaProvider call(
    String mangaId,
  ) {
    return MangaProvider(
      mangaId,
    );
  }

  @override
  MangaProvider getProviderOverride(
    covariant MangaProvider provider,
  ) {
    return call(
      provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaProvider';
}

/// See also [manga].
class MangaProvider extends AutoDisposeFutureProvider<Manga> {
  /// See also [manga].
  MangaProvider(
    String mangaId,
  ) : this._internal(
          (ref) => manga(
            ref as MangaRef,
            mangaId,
          ),
          from: mangaProvider,
          name: r'mangaProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaHash,
          dependencies: MangaFamily._dependencies,
          allTransitiveDependencies: MangaFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  MangaProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final String mangaId;

  @override
  Override overrideWith(
    FutureOr<Manga> Function(MangaRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MangaProvider._internal(
        (ref) => create(ref as MangaRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Manga> createElement() {
    return _MangaProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaRef on AutoDisposeFutureProviderRef<Manga> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _MangaProviderElement extends AutoDisposeFutureProviderElement<Manga>
    with MangaRef {
  _MangaProviderElement(super.provider);

  @override
  String get mangaId => (origin as MangaProvider).mangaId;
}

String _$chapterFeedHash() => r'89993c8f0e0853c22df51cb42819d7645f2b426b';

/// Fetches all chapters for [mangaId], paginating internally (max 500/request).
/// Chapters are returned in API order (ascending by chapter number).
///
/// Copied from [chapterFeed].
@ProviderFor(chapterFeed)
const chapterFeedProvider = ChapterFeedFamily();

/// Fetches all chapters for [mangaId], paginating internally (max 500/request).
/// Chapters are returned in API order (ascending by chapter number).
///
/// Copied from [chapterFeed].
class ChapterFeedFamily extends Family<AsyncValue<List<Chapter>>> {
  /// Fetches all chapters for [mangaId], paginating internally (max 500/request).
  /// Chapters are returned in API order (ascending by chapter number).
  ///
  /// Copied from [chapterFeed].
  const ChapterFeedFamily();

  /// Fetches all chapters for [mangaId], paginating internally (max 500/request).
  /// Chapters are returned in API order (ascending by chapter number).
  ///
  /// Copied from [chapterFeed].
  ChapterFeedProvider call(
    String mangaId,
  ) {
    return ChapterFeedProvider(
      mangaId,
    );
  }

  @override
  ChapterFeedProvider getProviderOverride(
    covariant ChapterFeedProvider provider,
  ) {
    return call(
      provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterFeedProvider';
}

/// Fetches all chapters for [mangaId], paginating internally (max 500/request).
/// Chapters are returned in API order (ascending by chapter number).
///
/// Copied from [chapterFeed].
class ChapterFeedProvider extends AutoDisposeFutureProvider<List<Chapter>> {
  /// Fetches all chapters for [mangaId], paginating internally (max 500/request).
  /// Chapters are returned in API order (ascending by chapter number).
  ///
  /// Copied from [chapterFeed].
  ChapterFeedProvider(
    String mangaId,
  ) : this._internal(
          (ref) => chapterFeed(
            ref as ChapterFeedRef,
            mangaId,
          ),
          from: chapterFeedProvider,
          name: r'chapterFeedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterFeedHash,
          dependencies: ChapterFeedFamily._dependencies,
          allTransitiveDependencies:
              ChapterFeedFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ChapterFeedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final String mangaId;

  @override
  Override overrideWith(
    FutureOr<List<Chapter>> Function(ChapterFeedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterFeedProvider._internal(
        (ref) => create(ref as ChapterFeedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Chapter>> createElement() {
    return _ChapterFeedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterFeedProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChapterFeedRef on AutoDisposeFutureProviderRef<List<Chapter>> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _ChapterFeedProviderElement
    extends AutoDisposeFutureProviderElement<List<Chapter>>
    with ChapterFeedRef {
  _ChapterFeedProviderElement(super.provider);

  @override
  String get mangaId => (origin as ChapterFeedProvider).mangaId;
}

String _$mangaSearchHash() => r'b2a7521e593a96336d21374dc66ad4e494b13a2b';

/// See also [MangaSearch].
@ProviderFor(MangaSearch)
final mangaSearchProvider =
    AutoDisposeAsyncNotifierProvider<MangaSearch, MangaSearchState>.internal(
  MangaSearch.new,
  name: r'mangaSearchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mangaSearchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MangaSearch = AutoDisposeAsyncNotifier<MangaSearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
