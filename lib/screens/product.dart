import 'package:flutter/material.dart';
import 'package:m_store/models/product_item.dart';
import 'package:m_store/models/save_item.dart';
import 'package:m_store/models/cart_item.dart';
import 'package:intl/intl.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late Future<Welcome> _futureData;
  ProductItem? _selectedItem; // เก็บข้อมูลสินค้าไว้ใช้ที่ bottomNavigationBar

  @override
  void initState() {
    super.initState();
    _futureData = loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    final int productId = ModalRoute.of(context)!.settings.arguments as int;

    // เช็คว่าสินค้าชิ้นนี้อยู่ในตะกร้าแล้วหรือยัง
    bool isInCart = cartData.any((e) => e.id == _selectedItem?.id);

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue),
      body: FutureBuilder<Welcome>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading product"));
          }

          final item = snapshot.data!.productItems.firstWhere(
            (e) => e.id == productId,
          );

          // เมื่อโหลดข้อมูลเสร็จ ให้เก็บค่าลงตัวแปรที่อยู่นอก Scope ของ Builder
          // และสั่ง WidgetsBinding เพื่อไม่ให้เกิด Error ตอนสร้าง Widget
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedItem != item) {
              setState(() {
                _selectedItem = item;
              });
            }
          });

          bool isFavorite = saveData.any((e) => e.id == item.id);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFavorite) {
                            saveData.removeWhere((e) => e.id == item.id);
                          } else {
                            saveData.add(
                              SaveItem(
                                id: item.id,
                                name: item.name,
                                imageUrl: item.imageUrl,
                                price: item.price,
                              ),
                            );
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFavorite
                                  ? 'Removed from favorites'
                                  : 'Saved to favorites',
                              textAlign: TextAlign.center,
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.pinkAccent : Colors.black,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Price : ${NumberFormat.currency(locale: 'th', symbol: '').format(item.price)} baht",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // ส่วนของปุ่มด้านล่าง
      bottomNavigationBar: _selectedItem == null
          ? const SizedBox.shrink() // ถ้ายังโหลดข้อมูลไม่เสร็จ ไม่ต้องโชว์ปุ่ม
          : Container(
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: isInCart
                      ? OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            foregroundColor: Colors.blue, // สีของ Icon และ Text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => Navigator.pushNamed(context, '/cart'),
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text(
                            'See Cart',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: isInCart
                              ? () => Navigator.pushNamed(context, '/cart')
                              : () {
                                  setState(() {
                                    cartData.add(
                                      CartItem(
                                        id: _selectedItem!.id,
                                        name: _selectedItem!.name,
                                        imageUrl: _selectedItem!.imageUrl,
                                        price: _selectedItem!.price,
                                        quantity: 1,
                                      ),
                                    );
                                  });
                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Added to cart',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: Colors.black.withValues(
                                        alpha: 0.8,
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                          icon: Icon(
                            isInCart
                                ? Icons.shopping_cart
                                : Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          label: Text(
                            isInCart ? 'See Cart' : 'Add to Cart',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
