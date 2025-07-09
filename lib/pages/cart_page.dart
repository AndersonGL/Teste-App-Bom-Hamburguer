
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import 'payment_page.dart';

/// Página do carrinho de compras
/// Esta página exibe os itens adicionados ao carrinho e o total da compra.
/// O usuário pode finalizar o pedido a partir desta página.
class CartPage extends StatelessWidget {
  final CartController cart;

  const CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(cart.items[i].name),
                subtitle: Text('R\$ \${cart.items[i].price.toStringAsFixed(2)}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Total: R\$ \${cart.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentPage(cart: cart)));
                  },
                  child: Text('Finalizar Pedido'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
