import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _nameController = TextEditingController();

  void _finalizeOrder() {
    final name = _nameController.text.trim();
    final cart = context.read<CartController>();

    if (name.isEmpty) return;

    final total = cart.total.toStringAsFixed(2);
    final items = cart.items.map((e) => e.name).join(', ');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pedido Finalizado!'),
        content: Text('Cliente: $name\nItens: $items\nTotal: R\$ $total'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              cart.clear();
              Navigator.of(context)
                  .popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Nome do Cliente:'),
            TextField(controller: _nameController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _finalizeOrder,
              child: const Text('Finalizar Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}