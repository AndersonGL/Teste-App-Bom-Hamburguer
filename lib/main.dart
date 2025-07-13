import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// models/item_model.dart
enum ItemType { sandwich, side, drink }

class Item {
  final String id;
  final String name;
  final double price;
  final ItemType type;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
  });
}

/// data/items_data.dart
final List<Item> availableItems = [
  Item(id: '1', name: 'X-Burger', price: 5.00, type: ItemType.sandwich),
  Item(id: '2', name: 'X-Egg', price: 4.50, type: ItemType.sandwich),
  Item(id: '3', name: 'X-Bacon', price: 7.00, type: ItemType.sandwich),
  Item(id: '4', name: 'Batata frita', price: 2.00, type: ItemType.side),
  Item(id: '5', name: 'Refrigerante', price: 2.50, type: ItemType.drink),
];

/// controllers/cart_controller.dart
class CartController extends ChangeNotifier {
  final List<Item> _cartItems = [];

  List<Item> get cartItems => List.unmodifiable(_cartItems);

  String? addItem(Item item) {
    // Validation
    final bool hasSandwich =
        _cartItems.any((cartItem) => cartItem.type == ItemType.sandwich);
    final bool hasSide =
        _cartItems.any((cartItem) => cartItem.type == ItemType.side);
    final bool hasDrink =
        _cartItems.any((cartItem) => cartItem.type == ItemType.drink);

    if (item.type == ItemType.sandwich && hasSandwich) {
      return 'Você pode adicionar apenas um sanduíche.';
    }
    if (item.type == ItemType.side && hasSide) {
      return 'Você pode adicionar apenas uma batata frita.';
    }
    if (item.type == ItemType.drink && hasDrink) {
      return 'Você pode adicionar apenas um refrigerante.';
    }

    _cartItems.add(item);
    notifyListeners();
    return null; // No error
  }

  void removeItem(Item item) {
    _cartItems.removeWhere((cartItem) => cartItem.id == item.id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get subtotal {
    return _cartItems.fold(0.0, (double sum, Item item) => sum + item.price);
  }

  double get discountAmount {
    double discount = 0.0;
    final bool hasSandwich =
        _cartItems.any((item) => item.type == ItemType.sandwich);
    final bool hasFries = _cartItems.any((item) => item.type == ItemType.side);
    final bool hasDrink =
        _cartItems.any((item) => item.type == ItemType.drink);

    if (hasSandwich && hasFries && hasDrink) {
      discount = subtotal * 0.20; // 20%
    } else if (hasSandwich && hasDrink) {
      discount = subtotal * 0.15; // 15%
    } else if (hasSandwich && hasFries) {
      discount = subtotal * 0.10; // 10%
    }
    return discount;
  }

  double get finalPrice {
    return subtotal - discountAmount;
  }

  bool get isEmpty => _cartItems.isEmpty;
}

/// widgets/item_tile.dart
class ItemTile extends StatelessWidget {
  final Item item;

  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final String? errorMessage =
                    context.read<CartController>().addItem(item);
                if (errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} adicionado ao carrinho!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// widgets/cart_summary.dart
class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = context.watch<CartController>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildSummaryRow('Subtotal:', cartController.subtotal),
          _buildSummaryRow('Desconto:', -cartController.discountAmount,
              isDiscount: true),
          const Divider(),
          _buildSummaryRow(
            'Total:',
            cartController.finalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black87,
            ),
          ),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// pages/payment_page.dart
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _customerNameController = TextEditingController();
  bool _paymentConfirmed = false;

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = context.read<CartController>();
    final double finalPrice = cartController.finalPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _paymentConfirmed
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 80),
                    const SizedBox(height: 20),
                    Text(
                      'Pedido de R\$ ${finalPrice.toStringAsFixed(2)} confirmado para ${_customerNameController.text}!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Agradecemos a sua preferência!',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        cartController.clearCart(); // Clear cart after order
                        Navigator.of(context)
                            .popUntil((Route<dynamic> route) => route.isFirst); // Go back to home
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text('Voltar ao Início'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Total a pagar: R\$ ${finalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Informe seu nome para finalizar o pedido:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Seu Nome',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_customerNameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, digite seu nome.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        setState(() {
                          _paymentConfirmed = true;
                        });
                      }
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Confirmar Pagamento'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// pages/cart_page.dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: cartController.isEmpty
                ? const Center(
                    child: Text(
                      'Seu carrinho está vazio.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Item item = cartController.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text('R\$ ${item.price.toStringAsFixed(2)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_shopping_cart, color: Colors.red),
                            onPressed: () {
                              cartController.removeItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} removido do carrinho.'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (!cartController.isEmpty) const CartSummary(),
          if (!cartController.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => const PaymentPage()),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Finalizar Pedido'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Make button wider
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// pages/home_page.dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BOM HAMBURGUER 🍔'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => const CartPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: Text(
                '${cartController.cartItems.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: availableItems.length,
        itemBuilder: (BuildContext context, int index) {
          final Item item = availableItems[index];
          return ItemTile(item: item);
        },
      ),
      floatingActionButton: cartController.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) => const CartPage()),
                );
              },
              label: Text('Ver Carrinho (${cartController.cartItems.length})'),
              icon: const Icon(Icons.shopping_cart),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// main.dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartController>(
      create: (BuildContext context) => CartController(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bom Hamburguer 🍔',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
