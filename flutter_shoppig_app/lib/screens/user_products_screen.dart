//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/products.dart';
//widgetd
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
//screens
import '../screens/edit_user_product_screen.dart';

class UserProducatsScreen extends StatelessWidget {
  static const routeName = '/UserProducts';

  const UserProducatsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(
      context,
      listen: false,
    ).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.itemsForEdit;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditUserProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: products.length <= 0
                ? Center(
                    child: Text('You have no products on sale'),
                  )
                : ListView.builder(
                    itemBuilder: ((_, index) => Column(
                          children: [
                            UserProductItem(product: products[index]),
                            Divider()
                          ],
                        )),
                    itemCount: products.length,
                  )),
      ),
      // body: const Center(child: Text('You have no products on sale.')),
    );
  }
}
