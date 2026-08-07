import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.subtotal);

  Future<void> loadCart() async {
    _items = await StorageService.loadCart();
    notifyListeners();
  }

  Future<void> addItem(Product product) async {
    final index =
        _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    await StorageService.saveCart(_items);
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    await StorageService.saveCart(_items);
    notifyListeners();
  }

  Future<void> incrementQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      await StorageService.saveCart(_items);
      notifyListeners();
    }
  }

  Future<void> decrementQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      await StorageService.saveCart(_items);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items = [];
    await StorageService.saveCart(_items);
    notifyListeners();
  }
}
