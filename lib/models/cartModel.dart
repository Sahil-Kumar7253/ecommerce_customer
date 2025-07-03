import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel{
  final String productId;
  int quantity;
  CartModel({
    required this.productId,
    required this.quantity
  });

  //convert json to object model
  factory CartModel.fromJson(Map<String, dynamic> json){
    return CartModel(
      productId: json["productId"] ?? "",
      quantity: json["quantity"] ?? 0
    );
  }

  //convert List<QuerySnapshot> to List<Model>
  static List<CartModel> fromJsonList(List<QueryDocumentSnapshot> snapshot){
    return snapshot
        .map((e) => CartModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }

}