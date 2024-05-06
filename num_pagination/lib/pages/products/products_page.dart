import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../repositories/product_repository.dart';
import '../product/product_page.dart';
import 'products_providers.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int page = 1;

  @override
  Widget build(BuildContext context) {
    final productList = ref.watch(getProductsProvider(page));

    return SafeArea(
      top: false,
      child: Scaffold(
        body: productList.when(
          data: (products) {
            return ListView.separated(
              itemCount: products.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ProductPage(id: product.id);
                      }),
                    );
                  },
                  child: ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.brand),
                  ),
                );
              },
            );
          },
          error: (e, st) => Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                e.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        bottomNavigationBar: totalProducts == 0 && totalPages == 1
            ? const SizedBox.shrink()
            : Card(
                margin: EdgeInsets.zero,
                elevation: 4,
                child: NumberPaginator(
                  numberPages: totalPages,
                  onPageChange: (int index) {
                    setState(() {
                      page = index + 1;
                    });
                  },
                ),
              ),
      ),
    );
  }
}
