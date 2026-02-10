import 'package:flutter/material.dart';
import 'package:m_store/models/product_model.dart';
import 'package:m_store/models/save_model.dart';
import 'package:m_store/widgets/product_card.dart';
import 'dart:convert'; // เพื่อใช้ jsonDecode
import 'package:flutter/services.dart'; // เพื่อใช้ rootBundle เพื่อไปเอาไฟล์ json จาก root มาใช้

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ProductList? productList;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json'); // อ่านไฟล์ json เก็บไว้ที่ jsonString
      Map<String, dynamic> jsonData = jsonDecode(jsonString); // แปลง jsonString เป็น Map, key=String value=dynamic(หมายความว่า key ต้องเป็น String แต่ valueเป็น type อะไรก็ได้)
      ProductList resProductList = ProductList.fromJson(jsonData); // แปลง Map เป็น OBJ
      setState(() {
        productList = resProductList;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'For you',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productList == null
          ? const Center(child: Text('ไม่พบข้อมูล'))
          : GridView.builder(
              itemCount: productList!.productItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final item = productList!.productItems[index];
                bool isFavorite = saveData.any((e) => e.id == item.id);

                return ProductCard(
                  name: item.name,
                  imageUrl: item.imageUrl,
                  price: item.price,
                  isFavorite: isFavorite,
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: item.id,
                    );
                    setState(() {});
                  },
                  onFavoriteTap: () {
                    setState(() {
                      if (saveData.any((e) => e.id == item.id)) {
                        saveData.removeWhere((e) => e.id == item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              textAlign: TextAlign.center,
                              'Removed from favorites',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      } else {
                        saveData.add(
                          SaveModel(
                            id: item.id,
                            name: item.name,
                            imageUrl: item.imageUrl,
                            price: item.price,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                             content: const Text(
                              textAlign: TextAlign.center,
                              'Saved to favorites',
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    });
                  },
                );
              },
            ),
    );
  }
}
