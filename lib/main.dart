import 'package:ecommerce_customer/providers/cart_provider.dart';
import 'package:ecommerce_customer/providers/user_provider.dart';
import 'package:ecommerce_customer/views/cart_page.dart';
import 'package:ecommerce_customer/views/checkout_page.dart';
import 'package:ecommerce_customer/views/discount_Page.dart';
import 'package:ecommerce_customer/views/home.dart';
import 'package:ecommerce_customer/views/home_nav.dart';
import 'package:ecommerce_customer/views/login.dart';
import 'package:ecommerce_customer/views/signup_page.dart';
import 'package:ecommerce_customer/views/specific_Product.dart';
import 'package:ecommerce_customer/views/updateProfile.dart';
import 'package:ecommerce_customer/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          "/" : (context) => const CheckUser(),
          "/login" : (context) => const LoginPage(),
          "/home" : (context) => const HomeNav(),
          "/signup" : (context) => const SignUpPage(),
          '/updateprofile' : (context) => const Updateprofile(),
          "/discountpage" : (context) => const DiscountPage(),
          "/specific" : (context) => const SpecificProduct(),
          "/viewproduct" : (context) => const ViewProduct(),
          "/cart" : (context) => const CartPage(),
          '/checkout' : (context) => const CheckoutPage(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
