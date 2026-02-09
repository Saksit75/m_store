import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // อย่าลืม import ตัวนี้
import 'package:intl/intl.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final double totalPrice = (args is num) ? args.toDouble() : 0.0;
    const String baseUrl = "https://m-store.com";

    final String qrData =
        "$baseUrl/totalPrice=${totalPrice.toStringAsFixed(2)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Scan & Pay',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Text(
              'Total: ฿${NumberFormat.currency(locale: 'th', symbol: '').format(totalPrice)}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
