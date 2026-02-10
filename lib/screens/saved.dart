import 'package:flutter/material.dart';
import 'package:m_store/models/save_model.dart';
import 'package:m_store/widgets/product_card.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: saveData.isEmpty ? const Center(child: Text('No saved items')) : GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: saveData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          SaveModel saveItem = saveData[index];
          bool isFavorite = saveData.any((e) => e.id == saveItem.id);
          return ProductCard(
            name: saveItem.name,
            imageUrl: saveItem.imageUrl,
            price: saveItem.price,
            isFavorite: isFavorite,
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/product',
                arguments: saveItem.id,
              );
              setState(() {});
            },
            onFavoriteTap: () {
              setState(() {
                if (saveData.any((e) => e.id == saveItem.id)) {
                  saveData.removeWhere((e) => e.id == saveItem.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        textAlign: TextAlign.center,
                        'Removed from saved',
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
                    SaveModel(
                      id: saveItem.id,
                      name: saveItem.name,
                      imageUrl: saveItem.imageUrl,
                      price: saveItem.price,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        textAlign: TextAlign.center,
                        'Item saved',
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
      ),
    );
  }
}
