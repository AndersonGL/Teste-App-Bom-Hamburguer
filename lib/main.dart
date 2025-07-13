import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/cart_controller.dart';
import 'pages/home_page.dart';

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
