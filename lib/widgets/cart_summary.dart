import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();
    return Column(
      children: [
        const Text('Resumo do Carrinho', style: TextStyle(fontSize: 18)),
        ...cart.items.map((e) => Text('${e.name} - R\$ ${e.price}')),
        const SizedBox(height: 10),
        Text('Total: R\$ ${cart.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}