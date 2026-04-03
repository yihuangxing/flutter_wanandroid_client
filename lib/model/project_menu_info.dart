class ProductMenuInfo {
  int id;
  String name;
  ProductMenuInfo({required this.id, required this.name});


  factory ProductMenuInfo.fromJson(Map<String, dynamic> json) => ProductMenuInfo(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
  );
}