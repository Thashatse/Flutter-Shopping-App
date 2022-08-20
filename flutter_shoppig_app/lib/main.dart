//Packages
import 'package:flutter/material.dart';
import 'package:flutter_shoppig_app/providers/auth.dart';
import 'package:flutter_shoppig_app/screens/orders_screen.dart';
import 'package:provider/provider.dart';
//providers
import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
//Screens
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_user_product_screen.dart';
import './screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_account_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: ((context) => Products('', '')),
          update: (_, auth, pastProducts) => Products(
            auth.token != null ? auth.token! : '',
            auth.userID != null ? auth.userID! : '',
            pastProducts?.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: ((ctx) => Orders('', '')),
          update: (_, auth, pastOrders) => Orders(
            auth.token != null ? auth.token! : '',
            auth.userID != null ? auth.userID! : '',
            pastOrders?.orders,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: const MaterialColor(
              0Xff000000, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
              const <int, Color>{
                50: const Color.fromRGBO(252, 217, 184, 1), //10
                100: const Color.fromRGBO(252, 217, 184, 1), //20%
                200: const Color.fromRGBO(252, 217, 184, 1), //30%
                300: const Color.fromRGBO(224, 145, 69, 1), //40%
                400: const Color.fromRGBO(224, 145, 69, 1), //50%
                500: const Color.fromRGBO(224, 145, 69, 1), //60%
                600: const Color.fromRGBO(41, 44, 53, 1), //70%
                700: const Color.fromRGBO(41, 44, 53, 1), //80%
                800: const Color.fromRGBO(23, 24, 29, 1), //90%
                900: const Color.fromRGBO(23, 24, 29, 1), //100%
              },
            ),
            fontFamily: "Poppins",
            textTheme: ThemeData.light().textTheme.copyWith(
                  titleLarge: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  titleMedium: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 19),
                  titleSmall: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  bodyLarge: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  bodyMedium: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17),
                  bodySmall: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  labelLarge: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                  labelMedium: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                  labelSmall: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                  displayLarge: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  displayMedium: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 17),
                  displaySmall: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                  headlineLarge: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 30),
                  headlineMedium: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                  headlineSmall: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 25)),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: ((context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
                ),
          routes: {
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProducatsScreen.routeName: (context) => UserProducatsScreen(),
            EditUserProductScreen.routeName: (context) =>
                EditUserProductScreen(),
            UserAccountScreen.routeName: (context) => UserAccountScreen(),
          },
        ),
      ),
    );
  }
}
