import 'dart:ffi';

import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  double get totalAmount {
    double total = (price * quantity);
    return total;
  }

  String get totalAmountString {
    return totalAmount.toStringAsFixed(2);
  }

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = Map<String, CartItem>();

  Map<String, CartItem> get items {
    return {..._items};
  }

  bool get hasItems {
    return _items.length > 0;
  }

  int get noOfItems {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.totalAmount;
    });
    return total;
  }

  String get totalAmountString {
    return totalAmount.toStringAsFixed(2);
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          quantity: value.quantity + 1,
          title: value.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          quantity: value.quantity - 1,
          title: value.title,
        ),
      );
      notifyListeners();
    } else {
      removeItem(productId);
      //removeItem calls notifyListeners already
    }
  }

  void clearCart() {
    _items = Map<String, CartItem>();
    notifyListeners();
  }
}
