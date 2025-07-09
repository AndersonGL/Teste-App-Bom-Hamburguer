
import 'package:flutter/material.dart';
import 'pages/home_page.dart';


// Bom Hambúrguer App
// This app allows users to order hamburgers, sides, and drinks.

void main() {   
  runApp(BomHamburguerApp());   
}

class BomHamburguerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bom Hambúrguer',
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
