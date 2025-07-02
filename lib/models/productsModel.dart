import 'package:cloud_firestore/cloud_firestore.dart';

class Productsmodel {
  String name;
  String description;
  String image;
  int old_Price;
  int new_Price;
  String category;
  String id;
  int maxQuantity;

  Productsmodel({
    required this.name,
    required this.description,
    required this.image,
    required this.old_Price,
    required this.new_Price,
    required this.category,
    required this.id,
    required this.maxQuantity,
  });

  factory Productsmodel.fromJson(Map<String, dynamic> json, String id) {
    return Productsmodel(
      name: json['name'] ?? '',
      description: json['desc'] ?? 'No description',
      image: json['image'] ?? '',
      old_Price: json['old_Price'] ?? 0,
      new_Price: json['new_Price'] ?? 0,
      category: json['category'] ?? '',
      id: id,
      maxQuantity: json['maxQuantity'] ?? 0,
    );
  }

  //convert List<QueryDocumentSnapshots> to List<Productsmodel>

  static List<Productsmodel> fromSnapshotList(
    List<QueryDocumentSnapshot> snapshot,
  ) {
    return snapshot.map((doc) {
      return Productsmodel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
