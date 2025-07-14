import 'package:flutter/material.dart';
import '../models/item_model.dart';

class CartController extends ChangeNotifier {
  final List<ItemModel> _items = [];

  List<ItemModel> get items => _items;

  void addItem(ItemModel item) {
    final exists = _items.where((e) => e.category == item.category);
    if (exists.isNotEmpty) {
      throw Exception('Só é permitido um item da categoria ${item.category}');
    }
    _items.add(item);
    notifyListeners();
  }

  double get total {
    double base = _items.fold(0, (sum, item) => sum + item.price);
    return base - _getDiscount(base);
  }

  double _getDiscount(double base) {
    final hasSandwich = _items.any((e) => e.category == 'sanduiche');
    final hasFries = _items.any((e) => e.name == 'Batata Frita');
    final hasSoda = _items.any((e) => e.name == 'Refrigerante');

    if (hasSandwich && hasFries && hasSoda) return base * 0.2;
    if (hasSandwich && hasSoda) return base * 0.15;
    if (hasSandwich && hasFries) return base * 0.10;

    return 0.0;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}