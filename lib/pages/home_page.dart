import 'package:flutter/material.dart';
import '../data/items_data.dart';
import '../widgets/item_tile.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOM HAMBURGUER 🍔'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartPage()));
            },
          )
        ],
      ),
      body: ListView(
        children: items.map((e) => ItemTile(item: e)).toList(),
      ),
    );
  }
}