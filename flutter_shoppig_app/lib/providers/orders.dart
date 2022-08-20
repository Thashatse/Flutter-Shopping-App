import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//Consts
import '../consts/system_consts.dart';
//Models
import '../models/Exceptions/http_exception.dart';
import './cart.dart' show CartItem;

class OrderItem {
  final String Id;
  final double totalAmount;
  final DateTime dateTime;
  final List<CartItem> products;

  String get totalAmountString {
    return totalAmount.toStringAsFixed(2);
  }

  OrderItem({
    required this.Id,
    required this.totalAmount,
    required this.dateTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  late String authToken;
  late String userId;
  // ignore: avoid_init_to_null
  Orders(this.authToken, this.userId, [List<OrderItem>? items = null]) {
    if (items == null) {
      _orders = [];
    } else {
      _orders = items;
    }
  }

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  bool get hasItems {
    return _orders.length > 0;
  }

  Future<void> fetchAndSetOrders() async {
    Uri url = Uri.parse(
        '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.orderEndpoint}/$userId.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final List<OrderItem> apiOrders = [];

      if (response.statusCode == 200) {
        if (response.body != 'null') {
          var responseBodyData =
              json.decode(response.body) as Map<String, dynamic>;

          responseBodyData.forEach(
            (key, Values) {
              apiOrders.add(
                OrderItem(
                  Id: key,
                  totalAmount: Values['totalAmount'],
                  dateTime: DateTime.parse(Values['dateTime']),
                  products: (Values['products'] as List<dynamic>)
                      .map(
                        (itemValue) => CartItem(
                          id: itemValue['id'],
                          title: itemValue['title'],
                          quantity: itemValue['quantity'],
                          price: itemValue['price'],
                        ),
                      )
                      .toList(),
                ),
              );
            },
          );
        }
      } else {
        throw HTTPException(message: "Server did not return an 'OK' result.");
      }

      _orders = apiOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw Exception();
    }
    return Future<void>.value();
  }

  Future<void> addOrder({
    required List<CartItem> cartProducts,
    required double totalAmount,
  }) async {
    Uri url = Uri.parse(
        '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.orderEndpoint}/$userId.json?auth=$authToken');

    final orderDateTime = DateTime.now();
    var response = await http.post(
      url,
      body: json.encode(
        {
          'totalAmount': totalAmount,
          'dateTime': orderDateTime.toIso8601String(),
          'products': cartProducts
              .map((element) => {
                    'id': element.id,
                    'title': element.title,
                    'quantity': element.quantity,
                    'price': element.price,
                  })
              .toList(),
        },
      ),
    );

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);

      var dbID = responseBody['name'] as String;
      if (dbID.isNotEmpty) {
        var newOrder = OrderItem(
            Id: dbID,
            totalAmount: totalAmount,
            dateTime: orderDateTime,
            products: cartProducts);

        _orders.insert(0, newOrder);

        notifyListeners();
      }
    } else {
      throw HTTPException(message: "Server did not return an 'OK' result.");
    }
  }

  Future<void> clearOrders() async {
    final ordersToDelete = [..._orders];
    var success = false;

    ordersToDelete.forEach((orderToDelte) {
      final index =
          _orders.indexWhere((element) => element.Id == orderToDelte.Id);
      OrderItem? order = _orders[index];
      _orders.removeAt(index);
      notifyListeners();

      Uri url = Uri.parse(
          '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.orderEndpoint}/$userId/$orderToDelte.Id.json?auth=$authToken');

      http.delete(url).then(
        (response) {
          if (response.statusCode == 200) {
            order = null;
          } else {
            success = false;
            _orders.insert(index, order!);
          }
        },
      );
    });

    notifyListeners();
    if (!success) {
      Future<void>.value(
        // ignore: void_checks
        throw HTTPException(
            message: 'An error occured comunicating with the server'),
      );
    } else {
      return Future<void>.value();
    }
  }
}
