//package
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
//providers
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              DateFormat('hh:mm EEE, dd MMM yyyy')
                  .format(widget.order.dateTime),
            ),
            subtitle: Text('Order Value R ${widget.order.totalAmountString}'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
                height: min((widget.order.products.length * 20.0 + 100), 200),
                padding: EdgeInsets.all(5),
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    var product = widget.order.products[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Qty: ${product.quantity} | Total: R ${product.totalAmountString}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }),
                  itemCount: widget.order.products.length,
                ))
        ],
      ),
    );
  }
}
