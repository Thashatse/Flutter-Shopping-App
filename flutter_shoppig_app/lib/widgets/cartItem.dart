//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/cart.dart';
//widgets

//Enums

class CartItemWiget extends StatelessWidget {
  final String productID;
  final CartItem item;

  const CartItemWiget({
    Key? key,
    required this.productID,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: ((direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).errorColor,
                ),
                Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 21,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            ),
            content: Text(
              'Are you sure want to remove ${item.title} from your cart?',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 15),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 15),
                  )),
            ],
          ),
        );
      }),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productID);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 25,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('R ${item.price}'),
                ),
              ),
              backgroundColor: Theme.of(context).accentColor,
            ),
            title: Text('${item.title}'),
            subtitle: Text('R ${item.totalAmountString}'),
            trailing: Text('${item.quantity}x'),
          ),
        ),
      ),
    );
  }
}
