import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavrouitsOnly;

  const ProductsGrid({
    Key? key,
    required this.showFavrouitsOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavrouitsOnly ? productsData.favouriteItems : productsData.items;

    return products.length > 0
        ? GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: ((context, index) => ChangeNotifierProvider.value(
                  value: products[index],
                  child: ProductItem(),
                )),
          )
        : Center(
            child: Text(
              showFavrouitsOnly
                  ? 'You have no favorite products'
                  : 'No Products',
            ),
          );
  }
}
