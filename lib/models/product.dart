import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/ulr_list.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(
      BuildContext context, String token, String userID) async {
    try {
      _toggleFavorite();

      await http.put(
        Uri.parse('${UrlList.userFavorite}/$userID/$id.json?auth=$token'),
        body: jsonEncode(isFavorite),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Não foi possivel adicionar aos favoritos, erro $error. Estamos desfazendo a operação.'),
        duration: const Duration(seconds: 2),
      ));
      _toggleFavorite();
    }
  }
}
