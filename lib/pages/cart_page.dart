import 'package:flutter/material.dart';
import '../widgets/cart_summary.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Column(
        children: [
          const Expanded(child: SingleChildScrollView(child: CartSummary())),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              child: const Text('Finalizar Pedido'),
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PaymentPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}