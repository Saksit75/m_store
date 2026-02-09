import 'package:flutter/material.dart';
import 'package:m_store/models/product_item.dart';
import 'package:m_store/models/save_item.dart';
import 'package:m_store/widgets/product_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Welcome>
  _futureData; // late เท่ากับยังไม่กำหนดค่าแต่สัญญาว่าจะมีค่าส่งมาแน่นอน

  @override
  void initState() {
    super.initState();
    _futureData = loadJsonData();
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
      body: FutureBuilder<Welcome>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }
          final items = snapshot.data!.productItems;

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //1 แถวแสดง 2 items
              childAspectRatio: 0.8, // ปรับความสูง
            ),
            itemBuilder: (context, index) {
              final item = items[index];
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
                          backgroundColor: Colors.black.withValues(alpha: 0.8),
                          behavior: SnackBarBehavior.floating,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    } else {
                      saveData.add(
                        SaveItem(
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
                          backgroundColor: Colors.black.withValues(alpha: 0.8),
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
          );
        },
      ),
    );
  }
}
