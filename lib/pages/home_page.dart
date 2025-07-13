import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../models/item_model.dart';
import '../widgets/item_tile.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOM HAMBURGUER 🍔'),
        actions: <Widget>[
          Consumer<CartController>(
            builder:
                (BuildContext context, CartController cart, Widget? child) {
                  return Stack(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const CartPage(),
                            ),
                          );
                        },
                      ),
                      if (cart.items.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cart.items.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: AppData.availableItems.length,
        itemBuilder: (BuildContext context, int index) {
          final ItemModel item = AppData.availableItems[index];
          return ItemTile(item: item);
        },
      ),
    );
  }
}
