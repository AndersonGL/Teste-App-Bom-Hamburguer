import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Product> _products = [
    Product('Camiseta', 49.90),
    Product('Tênis', 199.90),
    Product('Boné', 39.90),
    Product('Jaqueta', 299.90),
  ];

  int _cartCount = 0;

  void _addToCart(Product product) {
    setState(() {
      _cartCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} adicionado ao carrinho!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja Simples',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loja Simples'),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: _cartCount > 0
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$_cartCount',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () => _addToCart(product),
                child: Text('Comprar'),
              ),
            );
          },
        ),
      ),
    );
  }
}