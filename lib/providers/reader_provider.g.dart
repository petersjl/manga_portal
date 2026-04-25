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
String _$readerModeHash() => r'dc4392b8a3710fc9a9ce2d044e733473b520f97d';

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

/// Reading mode for a specific manga — 'paged' or 'scroll'.
/// Vertical scroll mode is implemented in Feature 7; this always returns
/// 'paged' until then. The provider is parameterised per-manga now so
/// Feature 7 can persist per-manga preferences without an API change.
///
/// Copied from [readerMode].
@ProviderFor(readerMode)
const readerModeProvider = ReaderModeFamily();

/// Reading mode for a specific manga — 'paged' or 'scroll'.
/// Vertical scroll mode is implemented in Feature 7; this always returns
/// 'paged' until then. The provider is parameterised per-manga now so
/// Feature 7 can persist per-manga preferences without an API change.
///
/// Copied from [readerMode].
class ReaderModeFamily extends Family<String> {
  /// Reading mode for a specific manga — 'paged' or 'scroll'.
  /// Vertical scroll mode is implemented in Feature 7; this always returns
  /// 'paged' until then. The provider is parameterised per-manga now so
  /// Feature 7 can persist per-manga preferences without an API change.
  ///
  /// Copied from [readerMode].
  const ReaderModeFamily();

  /// Reading mode for a specific manga — 'paged' or 'scroll'.
  /// Vertical scroll mode is implemented in Feature 7; this always returns
  /// 'paged' until then. The provider is parameterised per-manga now so
  /// Feature 7 can persist per-manga preferences without an API change.
  ///
  /// Copied from [readerMode].
  ReaderModeProvider call(
    String mangaId,
  ) {
    return ReaderModeProvider(
      mangaId,
    );
  }

  @override
  ReaderModeProvider getProviderOverride(
    covariant ReaderModeProvider provider,
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
  String? get name => r'readerModeProvider';
}

/// Reading mode for a specific manga — 'paged' or 'scroll'.
/// Vertical scroll mode is implemented in Feature 7; this always returns
/// 'paged' until then. The provider is parameterised per-manga now so
/// Feature 7 can persist per-manga preferences without an API change.
///
/// Copied from [readerMode].
class ReaderModeProvider extends AutoDisposeProvider<String> {
  /// Reading mode for a specific manga — 'paged' or 'scroll'.
  /// Vertical scroll mode is implemented in Feature 7; this always returns
  /// 'paged' until then. The provider is parameterised per-manga now so
  /// Feature 7 can persist per-manga preferences without an API change.
  ///
  /// Copied from [readerMode].
  ReaderModeProvider(
    String mangaId,
  ) : this._internal(
          (ref) => readerMode(
            ref as ReaderModeRef,
            mangaId,
          ),
          from: readerModeProvider,
          name: r'readerModeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$readerModeHash,
          dependencies: ReaderModeFamily._dependencies,
          allTransitiveDependencies:
              ReaderModeFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ReaderModeProvider._internal(
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
    String Function(ReaderModeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReaderModeProvider._internal(
        (ref) => create(ref as ReaderModeRef),
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
  AutoDisposeProviderElement<String> createElement() {
    return _ReaderModeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReaderModeProvider && other.mangaId == mangaId;
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
mixin ReaderModeRef on AutoDisposeProviderRef<String> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _ReaderModeProviderElement extends AutoDisposeProviderElement<String>
    with ReaderModeRef {
  _ReaderModeProviderElement(super.provider);

  @override
  String get mangaId => (origin as ReaderModeProvider).mangaId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
