
import 'package:flutter/material.dart';
import '../models/item_model.dart';

class CartController extends ChangeNotifier {
  final List<ItemModel> _items = [];

  List<ItemModel> get items => _items;

  void addItem(ItemModel item) {
    final already = _items.any((e) => e.category == item.category);
    if (already) {
      throw Exception('Só é permitido um item da categoria: \${item.category}');
    }
    _items.add(item);
    notifyListeners();
  }

  double get total {
    double sum = _items.fold(0, (total, item) => total + item.price);
    return sum - _getDiscount(sum);
  }

  double _getDiscount(double base) {
    final hasS = _items.any((e) => e.category == 'sanduiche');
    final hasF = _items.any((e) => e.name == 'Batata Frita');
    final hasR = _items.any((e) => e.name == 'Refrigerante');
    if (hasS && hasF && hasR) return base * 0.2;
    if (hasS && hasR) return base * 0.15;
    if (hasS && hasF) return base * 0.10;
    return 0.0;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
