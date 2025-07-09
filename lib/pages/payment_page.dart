
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';

/// Página de pagamento
/// Esta página permite que o usuário finalize o pedido informando seu nome.
/// Após a confirmação, o carrinho é limpo e uma mensagem de agradecimento é exibida.

class PaymentPage extends StatefulWidget {
  final CartController cart;

  const PaymentPage({required this.cart});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final nameController = TextEditingController();

  void _finalizarPedido() {
    final name = nameController.text;
    if (name.isEmpty) return;
    final total = widget.cart.total;
    widget.cart.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pedido Confirmado'),
        content: Text('Obrigado, \$name! Total pago: R\$ \${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Text('Fechar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nome do Cliente')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _finalizarPedido, child: Text('Confirmar Pagamento')),
          ],
        ),
      ),
    );
  }
}
