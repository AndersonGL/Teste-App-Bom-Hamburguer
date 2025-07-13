import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartSummary extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onProceedToPayment;

  const CartSummary({
    required this.totalPrice,
    required this.onProceedToPayment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Total: ${currencyFormat.format(totalPrice)}',
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          onPressed: totalPrice > 0 ? onProceedToPayment : null,
          icon: const Icon(Icons.payment),
          label: const Text('Finalizar Pedido'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            textStyle: const TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
