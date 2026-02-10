class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final double price;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
  // แปลงจาก JSON เป็น Object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      price: json['price'],
    );
  }

}

class ProductList {
  final List<ProductModel> productItems;

  ProductList({required this.productItems});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    var list = json['product_items'] as List; //ดึง array ออกมาจาก key 'product_items'
    List<ProductModel> products = list.map((item) => ProductModel.fromJson(item)).toList();
    
    return ProductList(productItems: products);
  }
}