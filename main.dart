import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Represents an item available for purchase.
class ItemModel {
  final String name;
  final double price;
  final String category;

  ItemModel({required this.name, required this.price, required this.category});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          price == other.price &&
          category == other.category;

  @override
  int get hashCode => name.hashCode ^ price.hashCode ^ category.hashCode;
}

/// Provides the list of all available items in the application.
class AppData {
  static final List<ItemModel> availableItems = <ItemModel>[
    ItemModel(name: 'X Burger', price: 5.00, category: 'sanduiche'),
    ItemModel(name: 'X Egg', price: 4.50, category: 'sanduiche'),
    ItemModel(name: 'X Bacon', price: 7.00, category: 'sanduiche'),
    ItemModel(name: 'Batata Frita', price: 2.00, category: 'acompanhamento'),
    ItemModel(name: 'Refrigerante', price: 2.50, category: 'bebida'),
  ];
}

/// Manages the shopping cart state, including adding items, calculating total,
/// and applying discounts.
class CartController extends ChangeNotifier {
  final List<ItemModel> _items = <ItemModel>[];

  /// Returns an unmodifiable list of items currently in the cart.
  List<ItemModel> get items => List<ItemModel>.unmodifiable(_items);

  /// Adds an item to the cart. If an item of the same category already exists,
  /// it replaces the existing item, ensuring only one item per category
  /// (e.g., one sandwich, one side, one drink).
  void addItem(ItemModel item) {
    final int existingItemIndex = _items.indexWhere(
      (ItemModel e) => e.category == item.category,
    );

    if (existingItemIndex != -1) {
      _items[existingItemIndex] = item;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  /// Removes a specific item from the cart.
  void removeItem(ItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  /// Calculates the total price of items in the cart, applying discounts.
  double get total {
    final double base = _items.fold(
      0.0,
      (double sum, ItemModel item) => sum + item.price,
    );
    return base - _getDiscount(base);
  }

  /// Calculates the discount based on specific item combinations.
  double _getDiscount(double base) {
    final bool hasSandwich = _items.any(
      (ItemModel e) => e.category == 'sanduiche',
    );
    final bool hasFries = _items.any((ItemModel e) => e.name == 'Batata Frita');
    final bool hasSoda = _items.any((ItemModel e) => e.name == 'Refrigerante');

    if (hasSandwich && hasFries && hasSoda) {
      return base * 0.20; // 20% discount
    }
    if (hasSandwich && hasSoda) {
      return base * 0.15; // 15% discount
    }
    if (hasSandwich && hasFries) {
      return base * 0.10; // 10% discount
    }

    return 0.0;
  }

  /// Clears all items from the cart.
  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// A widget to display a single menu item with an add button.
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
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }
}

/// The home page displaying the list of available items.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOM HAMBURGUER 🍔'),
        actions: <Widget>[
          Consumer<CartController>(
            builder:
                (BuildContext context, CartController cart, Widget? child) {
                  return Stack(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const CartPage(),
                            ),
                          );
                        },
                      ),
                      if (cart.items.isNotEmpty)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cart.items.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: AppData.availableItems.length,
        itemBuilder: (BuildContext context, int index) {
          final ItemModel item = AppData.availableItems[index];
          return ItemTile(item: item);
        },
      ),
    );
  }
}

/// The page displaying the contents of the shopping cart.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Seu Carrinho')),
      body: Consumer<CartController>(
        builder: (BuildContext context, CartController cart, Widget? child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Seu carrinho está vazio!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ItemModel item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(currencyFormat.format(item.price)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            cart.removeItem(item);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item.name} removido do carrinho.',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CartSummary(
                  totalPrice: cart.total,
                  onProceedToPayment: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const PaymentPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A widget displaying the cart total and a button to proceed to payment.
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

/// The payment simulation page where the customer enters their name.
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _customerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartController cart = Provider.of<CartController>(
      context,
      listen: false,
    );
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
                    _showOrderConfirmation(context, cart.total, cart.items);
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
                Navigator.of(dialogContext).pop(); // Close dialog
                Navigator.of(context).popUntil(
                  (Route<dynamic> route) => route.isFirst,
                ); // Go back to home
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

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
          title: 'BOM HAMBURGUER',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.deepOrange,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
