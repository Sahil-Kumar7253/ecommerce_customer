import 'package:ecommerce_customer/views/home.dart';
import 'package:flutter/material.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int selectedIndex = 0;

  List pages = [
    HomePage(),
    Text("Order"),
    Text("Cart"),
    Text("Profile"),
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
             icon: Icon(Icons.shopping_cart_outlined),
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
