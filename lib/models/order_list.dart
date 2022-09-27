import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import '../utils/ulr_list.dart';
import 'order.dart';
import 'cart.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userID;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userID = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response =
        await http.get(Uri.parse('${UrlList.urlOrders}/$_userID.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderID, orderData) {
      items.add(
        Order(
          id: orderID,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productID: item['productID'],
              name: item['name'],
              quantidy: item['quantidy'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${UrlList.urlOrders}/$_userID.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalPrice,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'productID': cartItem.productID,
                  'name': cartItem.name,
                  'quantidy': cartItem.quantidy,
                  'price': cartItem.price,
                },
              )
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalPrice,
        products: cart.items.values.toList(),
        date: date,
      ),
    );

    notifyListeners();
  }
}
