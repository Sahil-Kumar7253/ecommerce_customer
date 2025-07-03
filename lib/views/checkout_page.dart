import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer/constant/payment.dart';
import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController couponController = TextEditingController();
  int discount = 0;
  int toPay = 0;
  String discountText = "";

  discountCalculator(int disPercentage,int  totalCost){
    discount = (disPercentage * totalCost) ~/ 100;
    setState(() {

    });
  }

  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      // 1. create payment intent on the server
      final data = await createPaymentIntent(name: user.name, address: user.address, amount: (cost*100).toString());

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(builder: (context,user,child) =>
            Consumer<CartProvider>(builder: (context,cart,child){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Details",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width* .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    user.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(user.email),
                                SizedBox(height: 5),
                                Text(user.address),
                                SizedBox(height: 5),
                                Text(user.phone),
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: (){
                                Navigator.pushNamed(context, "/updateprofile");
                              },
                              icon: Icon(Icons.edit_outlined)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Have a Coupons?"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: couponController,
                            decoration: InputDecoration(
                              labelText: "Coupon Code",
                              hintText: "Enter Coupon Code",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            QuerySnapshot querySnapshot = await DbService().verifyDiscount(code: couponController.text.toUpperCase());

                            if(querySnapshot.docs.isNotEmpty){
                              QueryDocumentSnapshot doc = querySnapshot.docs.first;
                              String code = doc.get("code");
                              int percentage = doc.get("discount");

                              print("Discount Code : $code");
                              discountText = "a discount of $percentage % will be applied on checkout.";

                              discountCalculator(percentage, cart.totalCost);
                            }else{
                              print("No discount code fount");
                              discountText = "No discount code found";
                            }
                            setState(() {});
                          },
                          child: Text("Apply"),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    discountText == "" ? Container() : Text(discountText),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                        "Total Quantity of Products : ${cart.totalQuantity}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "Total Cost : ₹ ${cart.totalCost}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                    ),
                    discount == 0 ? Container() : Divider(),
                    discount == 0 ? Container() : Text(
                      "Extra Discount : - ₹ $discount",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Divider(),
                    Text(
                      "Total Amount to Pay : ₹ ${cart.totalCost - discount}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
              );
            }),
        ),
      ),

      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(10),
        child: ElevatedButton(onPressed: () async {
          final user = Provider.of<UserProvider>(context, listen: false);
          if(user.name == "" ||
              user.phone == "" ||
              user.address == "" ||
              user.email == ""){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill all the details"))
            );
            return ;
          }

          await initPaymentSheet(Provider.of<CartProvider>(context, listen: false).totalCost - discount);

          try{
            await Stripe.instance.presentPaymentSheet();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful", style: TextStyle(color: Colors.white)),backgroundColor: Colors.greenAccent));

          } catch(e){
            print("Error in payment sheet : $e");
            print("Payment sheet failed");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Failed", style: TextStyle(color: Colors.white)),backgroundColor: Colors.redAccent));
          }
        },
        child: Text("Proceed To Pay"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white
        ),
        ),
      ),
    );
  }
}
