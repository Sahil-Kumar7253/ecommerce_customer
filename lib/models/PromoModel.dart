import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannersModel {
  final String title;
  final String image;
  final String category;
  final String Id;

  PromoBannersModel({
    required this.title,
    required this.image,
    required this.category,
    required this.Id,
  });

  //convert to json to object model
  factory PromoBannersModel.fromJson(Map<String,dynamic> json, String id){
    return PromoBannersModel(
      title: json["name"] ??"",
      image: json["image"] ??"",
      category: json["category"] ??"",
      Id: id,
    );
  }

  //convert List<QueryDocumentSnapshots> to List<Productsmodel>
  static List<PromoBannersModel>fromJsonList(List<QueryDocumentSnapshot> list){
     return list.map((e) => PromoBannersModel.fromJson(e.data() as Map<String,dynamic>, e.id)).toList();
  }

}