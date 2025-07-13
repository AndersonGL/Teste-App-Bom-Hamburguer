import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../models/item_model.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;

  const ItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    currencyFormat.format(item.price),
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Semantics(
              label: 'Adicionar ${item.name} ao carrinho',
              button: true,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CartController>(
                    context,
                    listen: false,
                  ).addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} adicionado ao carrinho!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Adicionar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
