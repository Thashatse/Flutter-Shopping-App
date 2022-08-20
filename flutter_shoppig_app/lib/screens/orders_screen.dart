//package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//providers
import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/orderItem.dart' as OrderWidget;

class OrderScreen extends StatefulWidget {
  static const String routeName = '/Orders';

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _ordersFuture;

  Future _ObtainOrdersFuture() {
    return Provider.of<Orders>(
      context,
      listen: false,
    ).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _ObtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: ((ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('An error occured loading you order.'),
              );
            } else {
              return Consumer<Orders>(
                builder: ((context, orderData, child) => orderData.hasItems
                    ? ListView.builder(
                        itemBuilder: ((context, index) => OrderWidget.OrderItem(
                            order: orderData.orders[index])),
                        itemCount: orderData.orders.length,
                      )
                    : const Center(
                        child: Text('You have no past orders.'),
                      )),
              );
            }
          }
        }),
      ),
    );
  }
}
