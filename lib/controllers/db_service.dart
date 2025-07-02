import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  //read category
  Stream<QuerySnapshot> readCategory(){
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority" , descending: true)
        .snapshots();
  }
}