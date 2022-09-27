import 'dart:math';
import 'package:flutter/material.dart';

import 'product.dart';
import 'cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itensCount {
    return _items.length;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          productID: existingItem.productID,
          name: existingItem.name,
          quantidy: existingItem.quantidy + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productID: product.id,
          name: product.name,
          quantidy: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }

    if (_items[productID]?.quantidy == 1) {
      _items.remove(productID);
    } else {
      _items.update(
        productID,
        (existingItem) => CartItem(
          id: existingItem.id,
          productID: existingItem.productID,
          name: existingItem.name,
          quantidy: existingItem.quantidy - 1,
          price: existingItem.price,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantidy;
    });
    return total;
  }
}
