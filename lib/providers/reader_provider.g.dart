// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$imageQualityHash() => r'a66d04c231e59244f8d3f2ee5c540637a29e7aa5';

/// Current image quality mode, derived from the user's settings.
/// Returns 'data' (full resolution) or 'data-saver' (compressed).
///
/// Copied from [imageQuality].
@ProviderFor(imageQuality)
final imageQualityProvider = AutoDisposeProvider<String>.internal(
  imageQuality,
  name: r'imageQualityProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$imageQualityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ImageQualityRef = AutoDisposeProviderRef<String>;
String _$readingModeNotifierHash() =>
    r'a6c1d3c391ca954bf9be4bbf5a02859c2e2e5044';

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

abstract class _$ReadingModeNotifier
    extends BuildlessAutoDisposeNotifier<String> {
  late final String mangaId;

  String build(
    String mangaId,
  );
}

/// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
/// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
/// so the preference survives app restarts.
///
/// Copied from [ReadingModeNotifier].
@ProviderFor(ReadingModeNotifier)
const readingModeNotifierProvider = ReadingModeNotifierFamily();

/// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
/// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
/// so the preference survives app restarts.
///
/// Copied from [ReadingModeNotifier].
class ReadingModeNotifierFamily extends Family<String> {
  /// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
  /// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
  /// so the preference survives app restarts.
  ///
  /// Copied from [ReadingModeNotifier].
  const ReadingModeNotifierFamily();

  /// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
  /// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
  /// so the preference survives app restarts.
  ///
  /// Copied from [ReadingModeNotifier].
  ReadingModeNotifierProvider call(
    String mangaId,
  ) {
    return ReadingModeNotifierProvider(
      mangaId,
    );
  }

  @override
  ReadingModeNotifierProvider getProviderOverride(
    covariant ReadingModeNotifierProvider provider,
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
  String? get name => r'readingModeNotifierProvider';
}

/// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
/// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
/// so the preference survives app restarts.
///
/// Copied from [ReadingModeNotifier].
class ReadingModeNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ReadingModeNotifier, String> {
  /// Persists and exposes the reading mode ('paged' or 'scroll') for a specific
  /// manga. Defaults to 'paged' on first use. Persisted to LocalProgressService
  /// so the preference survives app restarts.
  ///
  /// Copied from [ReadingModeNotifier].
  ReadingModeNotifierProvider(
    String mangaId,
  ) : this._internal(
          () => ReadingModeNotifier()..mangaId = mangaId,
          from: readingModeNotifierProvider,
          name: r'readingModeNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readingModeNotifierHash,
          dependencies: ReadingModeNotifierFamily._dependencies,
          allTransitiveDependencies:
              ReadingModeNotifierFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ReadingModeNotifierProvider._internal(
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
  String runNotifierBuild(
    covariant ReadingModeNotifier notifier,
  ) {
    return notifier.build(
      mangaId,
    );
  }

  @override
  Override overrideWith(ReadingModeNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ReadingModeNotifierProvider._internal(
        () => create()..mangaId = mangaId,
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
  AutoDisposeNotifierProviderElement<ReadingModeNotifier, String>
      createElement() {
    return _ReadingModeNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadingModeNotifierProvider && other.mangaId == mangaId;
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
mixin ReadingModeNotifierRef on AutoDisposeNotifierProviderRef<String> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _ReadingModeNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ReadingModeNotifier, String>
    with ReadingModeNotifierRef {
  _ReadingModeNotifierProviderElement(super.provider);

  @override
  String get mangaId => (origin as ReadingModeNotifierProvider).mangaId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
