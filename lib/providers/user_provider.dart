import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier{
   StreamSubscription<DocumentSnapshot>? _userSubscription;

   String name = "";
   String email = "";
   String address = "";
   String phone = "";

   UserProvider(){
     LoadUserData();
   }

   // load user data
   void LoadUserData(){
     _userSubscription?.cancel();

     _userSubscription = DbService().readUserData().listen((event) {
         print(event.data());
         final UserModel data = UserModel.fromJson(event.data() as Map<String, dynamic>);
         name = data.name;
         email = data.email;
         address = data.address;
         phone = data.phone;
         notifyListeners();
     });
   }
}