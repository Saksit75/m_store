class CartItem {
  final int id;
  final String name;
  int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

List<CartItem> cartData = [];
