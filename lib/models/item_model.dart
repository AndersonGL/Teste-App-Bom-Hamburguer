class ItemModel {
  final String name;
  final double price;
  final String category;

  ItemModel({required this.name, required this.price, required this.category});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ category.hashCode;
}

class AppData {
  static final List<ItemModel> availableItems = <ItemModel>[
    ItemModel(name: 'X Burger', price: 5.00, category: 'sanduiche'),
    ItemModel(name: 'X Egg', price: 4.50, category: 'sanduiche'),
    ItemModel(name: 'X Bacon', price: 7.00, category: 'sanduiche'),
    ItemModel(name: 'Batata Frita', price: 2.00, category: 'acompanhamento'),
    ItemModel(name: 'Refrigerante', price: 2.50, category: 'bebida'),
  ];
}