import 'package:flutter/material.dart';
import 'package:m_store/models/product_model.dart';
import 'package:m_store/models/save_model.dart';
import 'package:m_store/models/cart_model.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  ProductList? productList;
  bool isLoading = true;
  ProductModel? _selectedItem;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }
  void loadProducts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json');
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      ProductList response = ProductList.fromJson(jsonData);
      setState(() {
        productList = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final int productId = ModalRoute.of(context)!.settings.arguments as int;
    if (productList != null && _selectedItem == null) {
      _selectedItem = productList!.productItems.firstWhere(
        (e) => e.id == productId,
      );
    }
    bool isFavorite = saveData.any((e) => e.id == _selectedItem?.id);
    bool isInCart = cartData.any((e) => e.id == _selectedItem?.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedItem == null
          ? const Center(child: Text('ไม่พบข้อมูล'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // รูปสินค้า
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                        image: NetworkImage(_selectedItem!.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ชื่อสินค้า + ปุ่ม Favorite
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedItem!.name,
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
                              saveData.removeWhere(
                                (e) => e.id == _selectedItem!.id,
                              );
                            } else {
                              saveData.add(
                                SaveModel(
                                  id: _selectedItem!.id,
                                  name: _selectedItem!.name,
                                  imageUrl: _selectedItem!.imageUrl,
                                  price: _selectedItem!.price,
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
                              backgroundColor: Colors.black.withValues(
                              alpha: 0.8,
                            ),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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

                  // ราคา
                  Text(
                    "Price : ${NumberFormat.currency(locale: 'th', symbol: '').format(_selectedItem!.price)} baht",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: _selectedItem == null
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withValues(alpha: (0.3))),
                  ],
                ),
                child: isInCart
                    ? OutlinedButton(
                        onPressed: () {
                          // นำทางไปหน้าตะกร้า
                          Navigator.pushNamed(context, '/cart');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'See Cart',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cartData.add(
                              CartModel(
                                id: _selectedItem!.id,
                                name: _selectedItem!.name,
                                imageUrl: _selectedItem!.imageUrl,
                                price: _selectedItem!.price,
                                quantity: 1,
                              ),
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Added to cart!',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}
