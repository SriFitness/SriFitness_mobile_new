import 'package:flutter/material.dart';
import 'package:srifitness_app/pages/marketplace/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  bool selected;

  CartItem({required this.product, this.quantity = 1, this.selected = false});
}

class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addProduct(Product product) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index != -1) {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index != -1) {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index != -1 && _items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void selectItem(Product product, bool selected) {
    final index = _items.indexWhere((item) => item.product == product);
    if (index != -1) {
      _items[index].selected = selected;
    }
    notifyListeners();
  }

  void removeSelectedItems() {
    _items.removeWhere((item) => item.selected);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.product.discountedPrice * item.quantity);
  }
}