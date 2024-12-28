
import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/marketplace/product_model.dart';

class Cart with ChangeNotifier {
final List<Product> _items = [];

List<Product> get items => _items;

void addProduct(Product product) {
_items.add(product);
notifyListeners();
}

void removeProduct(Product product) {
_items.remove(product);
notifyListeners();
}

int get itemCount => _items.length;
}