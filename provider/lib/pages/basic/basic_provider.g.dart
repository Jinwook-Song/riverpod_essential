// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$helloHash() => r'5b227dc010715a08549fb294b8495fd4737f1288';

/// See also [hello].
@ProviderFor(hello)
final helloProvider = AutoDisposeProvider<String>.internal(
  hello,
  name: r'helloProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$helloHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef HelloRef = AutoDisposeProviderRef<String>;
String _$worldHash() => r'f1b28d3ef45253c65ee5d63c080702fd4201205a';

/// See also [world].
@ProviderFor(world)
final worldProvider = Provider<String>.internal(
  world,
  name: r'worldProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$worldHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WorldRef = ProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
