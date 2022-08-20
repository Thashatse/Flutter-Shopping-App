//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/products.dart' show Product, Products;
//screens
import '../screens/edit_user_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  const UserProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(
        product.title,
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditUserProductScreen.routeName,
                arguments: product.id,
              );
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              } catch (error) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete ${product.title}'),
                  ),
                );
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ]),
      ),
    );
  }
}
