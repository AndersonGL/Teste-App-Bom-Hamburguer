import 'package:flutter/material.dart';
import '../models/item_model.dart';

class CartController extends ChangeNotifier {
  final List<ItemModel> _items = <ItemModel>[];

  List<ItemModel> get items => List<ItemModel>.unmodifiable(_items);

  void addItem(ItemModel item) {
    final int existingItemIndex = _items.indexWhere(
      (ItemModel e) => e.category == item.category,
    );

    if (existingItemIndex != -1) {
      _items[existingItemIndex] = item;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(ItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  double get total {
    final double base = _items.fold(
      0.0,
      (double sum, ItemModel item) => sum + item.price,
    );
    return base - _getDiscount(base);
  }

  double _getDiscount(double base) {
    final bool hasSandwich = _items.any(
      (ItemModel e) => e.category == 'sanduiche',
    );
    final bool hasFries = _items.any((ItemModel e) => e.name == 'Batata Frita');
    final bool hasSoda = _items.any((ItemModel e) => e.name == 'Refrigerante');

    if (hasSandwich && hasFries && hasSoda) {
      return base * 0.20;
    }
    if (hasSandwich && hasSoda) {
      return base * 0.15;
    }
    if (hasSandwich && hasFries) {
      return base * 0.10;
    }

    return 0.0;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
