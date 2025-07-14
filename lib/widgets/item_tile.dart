import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../controllers/cart_controller.dart';

class ItemTile extends StatelessWidget {
  final ItemModel item;

  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
      trailing: ElevatedButton(
        onPressed: () {
          try {
            context.read<CartController>().addItem(item);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${item.name} adicionado!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
        child: const Text('Adicionar'),
      ),
    );
  }
}