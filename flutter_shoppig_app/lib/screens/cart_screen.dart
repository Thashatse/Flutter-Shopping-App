//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
//widgets
import '../widgets/cartItem.dart';
//Enums

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                cart.hasItems ? checkOutButton(cart: cart) : Spacer(),
                Spacer(),
                Chip(
                  label: Text('R ${cart.totalAmountString}'),
                  backgroundColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: cart.hasItems
              ? ListView.builder(
                  itemBuilder: ((ctx, i) {
                    var key = cart.items.keys.elementAt(i);
                    var item = cart.items.values.elementAt(i);
                    return CartItemWiget(
                      productID: key,
                      item: item,
                    );
                  }),
                  itemCount: cart.items.length,
                )
              : const Center(child: Text('Your cart is empty')),
        )
      ]),
    );
  }
}

class checkOutButton extends StatefulWidget {
  final Cart cart;
  const checkOutButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<checkOutButton> createState() => _checkOutButtonState();
}

var _isLoading = false;

class _checkOutButtonState extends State<checkOutButton> {
  void _checkOut(Cart cart) {
    setState(() {
      _isLoading = true;
    });

    var cartProducts = cart.items.values.toList();
    var totalAmount = cart.totalAmount;

    Provider.of<Orders>(context, listen: false)
        .addOrder(
      cartProducts: cartProducts,
      totalAmount: totalAmount,
    )
        .catchError(
      (error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Shomthing went wrong!'),
            content: Text('${error.toString()}'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      },
    ).then(
      (_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        cart.clearCart();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cart.totalAmount <= 0
          ? null
          : () {
              _checkOut(widget.cart);
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'Check Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
      textColor: Theme.of(context).accentColor,
    );
  }
}
