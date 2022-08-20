import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart' show Product, Products;
import '../providers/cart.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: FadeInImage(
            placeholder: AssetImage('assets/images/default-product-image.jpg'),
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.fill,
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Consumer<Product>(
                builder: (ctx, product, _) => Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
              color: Theme.of(context).indicatorColor,
              onPressed: (() async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .toggleFavorite(product.id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Failed to favorite ${product.title}'),
                    ),
                  );
                }
              }),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).indicatorColor,
              onPressed: (() {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    duration: Duration(
                      seconds: 5,
                    ),
                    content: Text(
                      '${product.title} was succesfuly added to your cart!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () => cart.removeSingleItem(product.id),
                    ),
                  ),
                );
              }),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
