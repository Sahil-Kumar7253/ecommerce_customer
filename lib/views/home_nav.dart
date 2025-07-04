import 'package:ecommerce_customer/providers/cart_provider.dart';
import 'package:ecommerce_customer/views/home.dart';
import 'package:ecommerce_customer/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'ordersPage.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int selectedIndex = 0;

  List pages = [
    HomePage(),
    OrdersPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value){
          setState(() {
            selectedIndex = value;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
           BottomNavigationBarItem(
             icon: Icon(Icons.home_outlined),
             label: "Home",
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.local_shipping_outlined),
             label: "Order",
           ),
           BottomNavigationBarItem(
             icon: Consumer<CartProvider>(
                 builder: (context,cart,child){
                   if(cart.carts.length > 0){
                     return Badge(
                       child: Icon(Icons.shopping_cart_outlined),
                       label: Text(cart.carts.length.toString()),
                       backgroundColor: Colors.green,
                     );
                   }
                   return Icon(Icons.shopping_cart_outlined);
                 },
             ),
             label: "Cart",
           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.person_outline),
             label: "Profile",
           ),
         ],
      )
    );
  }
}
