import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../models/item_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late CartController cart;

  @override
  void initState() {
    super.initState();
    cart = Provider.of<CartController>(context, listen: false);
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Cliente',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              Text(
                'Total a pagar: ${currencyFormat.format(cart.total)}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final itemsCopy = List<ItemModel>.from(cart.items);
                    _showOrderConfirmation(context, cart.total, itemsCopy);
                    cart.clear();
                  }
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirmar Pagamento'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderConfirmation(
    BuildContext context,
    double total,
    List<ItemModel> items,
  ) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final String customerName = _customerNameController.text.trim();

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Pedido Finalizado!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Cliente: $customerName'),
                const SizedBox(height: 10),
                const Text(
                  'Itens do Pedido:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...items
                    .map<Widget>(
                      (ItemModel item) => Text(
                        '${item.name} - ${currencyFormat.format(item.price)}',
                      ),
                    )
                    .toList(),
                const SizedBox(height: 10),
                Text(
                  'Total Final: ${currencyFormat.format(total)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Seu pedido será entregue em breve!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(
                  context,
                ).popUntil((Route<dynamic> route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
