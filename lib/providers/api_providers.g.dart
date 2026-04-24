// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mangaDexApiServiceHash() =>
    r'da9ec2c66b0280d7f0a904cf3d58af027add927d';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
