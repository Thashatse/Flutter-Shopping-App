//package
import 'package:flutter/material.dart';
import '../providers/products.dart' show Product;

class ProductEditModel with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  ProductEditModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.isFavorite = false,
  });

  Product toProductModel(String Id, String UserId) {
    return Product(
      id: Id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
      creatorId: UserId,
    );
  }
}
