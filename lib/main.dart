import 'package:flutter/material.dart';
import 'package:m_store/screens/cart.dart';
import 'package:m_store/screens/checkout.dart';
import 'package:m_store/screens/main_screen.dart';
import 'package:m_store/screens/product.dart';
import 'package:m_store/screens/saved.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'M-Store',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.grey)),
      home: const MainScreen(),
      routes: {
        // '/': (context) => const MainScreen(),
        '/saved': (context) => const Saved(),
        '/product': (context) => const Product(),
        '/cart': (context) => const Cart(),
        '/checkout': (context) => const Checkout(),
      }, // ใช้กับ navigate
    );
  }
}
