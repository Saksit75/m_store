import 'dart:convert';
import 'package:flutter/services.dart'; // ดึงไฟล์ในเครื่อง

Future<Welcome> loadJsonData() async {
  //ดึงไฟล์ออกมาเป็น String
  final String response = await rootBundle.loadString('assets/data.json');
  
  // ใช้ฟังก์ชัน welcomeFromJson แปลงเป็น Object
  final data = welcomeFromJson(response);
  
  return data;
}

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    List<ProductItem> productItems;

    Welcome({
        required this.productItems,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        productItems: List<ProductItem>.from(json["product_items"].map((x) => ProductItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "product_items": List<dynamic>.from(productItems.map((x) => x.toJson())),
    };
}

class ProductItem {
    int id;
    String name;
    String imageUrl;
    double price;

    ProductItem({
        required this.id,
        required this.name,
        required this.imageUrl,
        required this.price,
    });

    factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
        "price": price,
    };
}
