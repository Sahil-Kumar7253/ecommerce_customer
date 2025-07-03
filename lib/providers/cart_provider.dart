import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/models/cartModel.dart';
import 'package:ecommerce_customer/models/productsModel.dart';
import 'package:flutter/material.dart';


class CartProvider extends ChangeNotifier{
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<QuerySnapshot>? _productSubscription;

  bool isLoading = false;

  List<CartModel> carts = [];
  List<String> cartUids = [];
  List<Productsmodel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider(){
    readCardData();
  }

  void addToCart(CartModel cartModel){
    DbService().addToCart(cartData: cartModel);
    notifyListeners();
  }

  //Stream and read Card Data
  void readCardData(){
    isLoading = true;
    _cartSubscription?.cancel();
    _cartSubscription = DbService().readUserCart().listen((snapshot){
      List<CartModel> cartdata = CartModel.fromJsonList(snapshot.docs);
      carts = cartdata;
      cartUids = [];
      for(int i = 0; i<carts.length;i++){
        cartUids.add(carts[i].productId);
        print("cartUids: ${cartUids[i]}");
      }
      if(carts.length > 0){
        readCartProducts(cartUids);
      }
      isLoading = false;
      notifyListeners();

    });
  }

  //read Cart Product
  void readCartProducts(List<String> uids){
    _productSubscription?.cancel();
    _productSubscription = DbService().readProductByProductId(uids).listen((event) {
      List<Productsmodel> productsdata = Productsmodel.fromSnapshotList(event.docs);
      products = productsdata;
      isLoading = false;
      addCost(products, carts);
      calculateTotalQuantity();
      notifyListeners();
    });
  }

  //calculate total cost
  void addCost(List<Productsmodel> products, List<CartModel> carts){
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_){
      for(int i = 0; i<carts.length;i++){
        totalCost += products[i].new_Price * carts[i].quantity;
      }
      notifyListeners();
    });
    print("total cost : $totalCost");
  }

  //calculate total Quantity
  void calculateTotalQuantity(){
    totalQuantity = 0;
    for(int i = 0; i<carts.length;i++){
      totalQuantity += carts[i].quantity;
    }
    print("total quantity : $totalQuantity");
    notifyListeners();
  }

  //delete item from cart
  void deleteItemFromCart(String productId){
    DbService().deleteItemFromCart(productId: productId);
    readCardData();
    notifyListeners();
  }

  //decrease quantity
  void decreaseQuantity(String productId){
    DbService().decreaseQuantity(productId: productId);
    notifyListeners();
  }

}