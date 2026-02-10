class SaveModel {
  SaveModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  final int id;
  final String name;
  final String imageUrl;
  final double price;
}
List<SaveModel> saveData = [];
