import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//providers
import '../providers/cart.dart' as cartData;
//widgets
import '../widgets/badge.dart';
//screens
import '../screens/orders_screen.dart' as orders;
import '../screens/products_overview_screen.dart' as shop;
import '../screens/cart_screen.dart' as cart;
import '../screens/user_products_screen.dart' as sell;
import '../screens/user_account_screen.dart' as user;

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('The Shop'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shopify),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(shop.ProductsOverviewScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Order History'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(orders.OrderScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.sell),
          title: Text('Sell on The Shop'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(sell.UserProducatsScreen.routeName);
          },
        ),
        ListTile(
          leading: Icon(Icons.manage_accounts),
          title: Text('Account'),
          onTap: () {
            Navigator.of(context).pushNamed(user.UserAccountScreen.routeName);
          },
        ),
        Spacer(),
        ListTile(
          leading: Consumer<cartData.Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.noOfItems.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () => {},
            ),
          ),
          title: Text('My Cart'),
          onTap: () {
            Navigator.of(context).pushNamed(cart.CartScreen.routeName);
          },
        ),
      ]),
    );
  }
}
