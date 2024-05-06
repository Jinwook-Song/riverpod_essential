import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/product.dart';

part 'providers.g.dart';

@riverpod
Dio dio(DioRef ref) {
  return Dio(
    BaseOptions(baseUrl: 'https://dummyjson.com'),
  );
}

@riverpod
FutureOr<List<Product>> getProducts(GetProductsRef ref) async {
  // 요청을 token으로 취소할 수 있다.
  final cancelToken = CancelToken();
  Timer? timer;

  print('[getProductsProvider] initialized');
  ref.onDispose(() {
    print('[getProductsProvider] disposed, token cancelled, timer cancelled');
    timer?.cancel();
    cancelToken.cancel();
  });
  ref.onCancel(() {
    print('[getProductsProvider] cancelled');
  });
  ref.onResume(() {
    print('[getProductsProvider] resumed, timer cancelled');
    timer?.cancel();
  });
  ref.onAddListener(() {
    print('[getProductsProvider] listener added');
  });
  ref.onRemoveListener(() {
    print('[getProductsProvider] listener removed');
  });

  final response = await ref.watch(dioProvider).get(
        '/products',
        cancelToken: cancelToken,
      );

  /// keepAlive의 위치 중요. get method 호출 전에 keepAlive를 실행시키면
  /// 원하는대로 동작하지 않는다.
  /// 호출이 성공한 이후 keepAlive를 실행
  final keepAliveLink = ref.keepAlive();

  /// ref의 method들은 여러번 호출 될 수 있다.
  ref.onCancel(() {
    print('[getProductsProvider] cancelled, timer started');
    timer = Timer(const Duration(seconds: 10), () {
      keepAliveLink.close();
    });
  });

  final List productList = response.data['products'];

  print(productList[0]);

  final products = [
    for (final product in productList) Product.fromJson(product)
  ];

  return products;
}

@riverpod
FutureOr<Product> getProduct(
  GetProductRef ref, {
  required int productId,
}) async {
  print('[getProductProvider($productId)] initialized');
  ref.onDispose(() {
    print('[getProductProvider($productId)] disposed');
  });
  ref.onCancel(() {
    print('[getProductProvider($productId)] canceled');
  });
  ref.onResume(() {
    print('[getProductProvider($productId)] resumed');
  });
  ref.onAddListener(() {
    print('[getProductProvider($productId)] listener added');
  });
  ref.onRemoveListener(() {
    print('[getProductProvider($productId)] listener removed');
  });

  final response = await ref.watch(dioProvider).get('/products/$productId');

  final product = Product.fromJson(response.data);

  return product;
}
