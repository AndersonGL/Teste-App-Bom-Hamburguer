import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../models/item_model.dart';
import '../controllers/cart_controller.dart';
import 'cart_page.dart';

/// Bom Hambúrguer App
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cart = CartController();

  void _addToCart(ItemModel item) {
    try {
      cart.addItem(item);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Adicionado: \${item.name}')));
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(title: Text('Erro'), content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bom Hambúrguer'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage(cart: cart)),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('R\$ \${item.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _addToCart(item),
            ),
          );
        },
      ),
    );
  }
}
