import 'package:ecommerce_customer/Container/category_Container.dart';
import 'package:ecommerce_customer/Container/discount_Container.dart';
import 'package:ecommerce_customer/Container/promo_Container.dart';
import 'package:ecommerce_customer/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          PromoContainer(),
          DiscountContainer(),
          CategoryContainer()
        ],
      ),
    );
  }
}
