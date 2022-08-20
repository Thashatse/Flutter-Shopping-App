import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//Consts
import '../consts/system_consts.dart';
//Models
import '../models/Exceptions/http_exception.dart';
import '../models/product_edit_model.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String creatorId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.creatorId = '',
    this.isFavorite = false,
  });

  void toggleFavoriteStatuse() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  ProductEditModel toProductEditModel() {
    return ProductEditModel(
      id: id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
  }
}

class Products with ChangeNotifier {
  late String authToken;
  late String userId;
  // ignore: avoid_init_to_null
  Products(this.authToken, this.userId, [List<Product>? items = null]) {
    if (items == null) {
      _items = [];
    } else {
      _items = items;
    }
  }

  List<Product> _items = [];

  List<Product> get items {
    var itemsToRetun = [..._items];
    return itemsToRetun;
  }

  List<Product> get itemsForEdit {
    var itemsToRetun =
        _items.where((element) => element.creatorId == userId).toList();
    return itemsToRetun;
  }

  List<Product> get favouriteItems {
    var itemsToRetun =
        _items.where((element) => element.isFavorite == true).toList();
    return itemsToRetun;
  }

  Future<void> fetchAndSetProducts() async {
    final Uri url = Uri.parse(
        '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productEndpoint}.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<Product> apiProducts = [];

      if (response.statusCode == 200) {
        if (response.body != 'null') {
          var responseBodyData =
              json.decode(response.body) as Map<String, dynamic>;

          //#region User Regions
          final Uri urlForProductFavorites = Uri.parse(
              '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productFavoritesEndpoint}/${userId}.json?auth=$authToken');
          final favoritesResponse = await http.get(urlForProductFavorites);
          Map<String, dynamic> favoriteData = Map<String, dynamic>();
          if (favoritesResponse.statusCode == 200) {
            if (favoritesResponse.body != 'null') {
              favoriteData = json.decode(favoritesResponse.body);
            }
          }
          //#endregion

          responseBodyData.forEach(
            (productKey, productValues) {
              apiProducts.add(
                Product(
                  id: productKey,
                  title: productValues['title'],
                  description: productValues['description'],
                  price: productValues['price'],
                  imageUrl: productValues['imageUrl'],
                  creatorId: productValues['creatorId'],
                  isFavorite: favoriteData.isEmpty
                      ? false
                      : (favoriteData[productKey] ?? false),
                ),
              );
            },
          );
        }
      } else {
        throw HTTPException(message: "Server did not return an 'OK' result.");
      }

      _items = apiProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> updateProduct(ProductEditModel product) async {
    try {
      if (product.id == '' && product.id != null) {
        final Uri url = Uri.parse(
            '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productEndpoint}.json?auth=$authToken');

        var response = await http.post(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'creatorId': userId,
            },
          ),
        );

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);

          var dbID = responseBody['name'] as String;
          if (dbID.isNotEmpty) {
            Product updatedProduct = product.toProductModel(dbID, userId);
            _items.add(updatedProduct);
          }
        } else {
          throw HTTPException(message: "Server did not return an 'OK' result.");
        }
      } else {
        final Uri url = Uri.parse(
            '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productEndpoint}/${product.id}.json?auth=$authToken');

        var response = await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price
            },
          ),
        );

        if (response.statusCode == 200) {
          var productIndex =
              _items.indexWhere((element) => element.id == product.id);
          if (productIndex >= 0) {
            _items[productIndex] = product.toProductModel(product.id, userId);
          }
        }
      }
    } catch (error) {
      print(error);
      throw HTTPException(
          message: 'An error occured comunicating with the server.');
    }

    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? product = _items[productIndex];
    product.toggleFavoriteStatuse();
    notifyListeners();

    final Uri url = Uri.parse(
        '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productFavoritesEndpoint}/$userId/$productId.json?auth=$authToken');

    return http
        .put(
      url,
      body: json.encode(
        product.isFavorite,
      ),
    )
        .then(
      (response) {
        if (response.statusCode == 200) {
          product = null;
        } else {
          _items[productIndex] = product!;
          notifyListeners();
          throw HTTPException(
              message: 'An error occured comunicating with the server');
        }
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? product = _items[productIndex];
    if (product.creatorId != userId) {
      throw Exception('You may not delete a product you did not create');
    }
    _items.removeAt(productIndex);
    notifyListeners();

    final Uri url = Uri.parse(
        '${SystemConsts_Fierbase.apiBaseURL}${SystemConsts_Fierbase.productEndpoint}/$productId.json?auth=$authToken');

    return http.delete(url).then(
      (response) {
        if (response.statusCode == 200) {
          product = null;
        } else {
          _items.insert(productIndex, product!);
          notifyListeners();
          throw HTTPException(
              message: 'An error occured comunicating with the server');
        }
      },
    );
  }

  Product findByID(String id) {
    return _items.firstWhere(
      (element) => element.id == id,
    );
  }
}
