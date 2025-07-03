import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cartModel.dart';

class DbService{
  User? user = FirebaseAuth.instance.currentUser;

  //USER Data
  // add the user to firestore

  Future saveUserData({required String name, required String email, required String password}) async {
      try{
        Map<String, dynamic> data = {
          "name" : name,
          "email" : email,
          "password" : password
        };

        await FirebaseFirestore.instance
            .collection('shop_users')
            .doc(user!.uid)
            .set(data);
      }catch(e){
        print("error in saving user data : $e");
      }
  }

  //update other data in database
  Future updateUserData({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection('shop_users').doc(user!.uid).update(data);
  }

  //read current user data
  Stream<DocumentSnapshot> readUserData(){
    return FirebaseFirestore.instance
        .collection('shop_users')
        .doc(user!.uid)
        .snapshots();
  }

  //reading banner and promo
  Stream<QuerySnapshot> readPromo(){
    return FirebaseFirestore.instance
        .collection('shop_promos')
        .snapshots();
  }
  Stream<QuerySnapshot> readBanner(){
    return FirebaseFirestore.instance
        .collection('shop_banners')
        .snapshots();
  }

  //read coupons
  Stream<QuerySnapshot> readDiscount(){
    return FirebaseFirestore.instance
        .collection("shop_coupon")
        .orderBy("discount", descending: true)
        .snapshots();
  }

  //verify Coupons
  Future<QuerySnapshot> verifyDiscount({required String code}){
    print("Searching for Code : $code");
    return FirebaseFirestore.instance
        .collection("shop_coupon")
        .where("code", isEqualTo: code)
        .get();
  }

  //read category
  Stream<QuerySnapshot> readCategory(){
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority" , descending: true)
        .snapshots();
  }

  //Products
  //read product of specific category
  Stream<QuerySnapshot> readProductByCategory(String category){
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }

  //search product by productId
  Stream<QuerySnapshot> readProductByProductId(List<String> productId){
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where(FieldPath.documentId, whereIn: productId)
        .snapshots();
  }

  //Cart
  //display the User Cart

  Stream<QuerySnapshot> readUserCart(){
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("shop_cart")
        .snapshots();
  }

  //adding product to the cart
  Future addToCart({required CartModel cartData}) async {
    try{
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("shop_cart")
          .doc(cartData.productId)
          .update({
          'productId': cartData.productId,
          'quantity': FieldValue.increment(1)
      });
    }on FirebaseException catch(e){
      print("Firebase Exception : ${e.code}");
      if(e.code == "not-found"){
         //setData
        await FirebaseFirestore.instance
            .collection("shop_users")
            .doc(user!.uid)
            .collection("shop_cart")
            .doc(cartData.productId)
            .set({
          'productId': cartData.productId,
          'quantity': 1
        });
      }
    }
  }

  //delete specific product from the cart
  Future deleteItemFromCart({required String productId}) async {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("shop_cart")
          .doc(productId)
          .delete();
  }

  //empty after using cart
  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("shop_cart")
        .get()
        .then((querySnapshot) {
          for(DocumentSnapshot ds in querySnapshot.docs){
            ds.reference.delete();
          }
    });
  }

  //decrease the count
  Future decreaseQuantity({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("shop_cart")
        .doc(productId)
        .update({
      "quantity" : FieldValue.increment(-1)
    });
  }
}