//package
import 'package:flutter/material.dart';
import 'package:flutter_shoppig_app/providers/products.dart';
import 'package:flutter_shoppig_app/screens/user_account_screen.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/cart.dart';
//widgets
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
//Enums
import '../enums/ProductOverviewFilterOptions.dart';
//Screens
import '../screens/cart_screen.dart';

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/ProductsOverview';

  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreeState();
}

class _ProductsOverviewScreeState extends State<ProductsOverviewScreen> {
  var _showFavrouitsOnly = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Text('The Shop'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(_showFavrouitsOnly ? 'Your Favorites' : 'The Shop'),
              actions: <Widget>[
                Consumer<Cart>(
                  builder: (_, cart, ch) => Badge(
                    value: cart.noOfItems.toString(),
                    child: ch!,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.manage_accounts,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(UserAccountScreen.routeName);
                  },
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  onSelected: (FilterOptions selected) {
                    setState(() {
                      if (selected == FilterOptions.All) {
                        _showFavrouitsOnly = false;
                      } else if (selected == FilterOptions.Favorites) {
                        _showFavrouitsOnly = true;
                      }
                    });
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Show Favorites'),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ],
                ),
              ],
            ),
            drawer: AppDrawer(),
            body: ProductsGrid(showFavrouitsOnly: _showFavrouitsOnly),
          );
  }
}
