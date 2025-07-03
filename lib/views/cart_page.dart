import 'package:ecommerce_customer/Container/cart_container.dart';
import 'package:ecommerce_customer/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
      ),
      body: Consumer<CartProvider> (builder: (context, value, child){
        if(value.isLoading){
          return Center(child: CircularProgressIndicator());
        }
        else{
          if(value.carts.isEmpty){
            return Center(child: Text("No Items in Cart"));
          }else{
            return ListView.builder(
                itemCount: value.carts.length,
                itemBuilder: (context, index){
                  return CartContainer(
                      image: value.products[index].image,
                      name: value.products[index].name,
                      productId: value.products[index].id,
                      new_price: value.products[index].new_Price,
                      old_price: value.products[index].old_Price,
                      maxQuantity: value.products[index].maxQuantity,
                      selectedQuantity: value.carts[index].quantity
                  );
                }
            );
          }
        }
      }),

      bottomNavigationBar: Consumer<CartProvider>(builder: (context, value, child){
        if(value.carts.isEmpty){
          return SizedBox();
        }else{
          return Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total : ₹${value.totalCost}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ElevatedButton(
                    onPressed: (){
                        Navigator.pushNamed(context, "/checkout");
                    },
                    child: Text("Checkout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                )
              ],
            ),
          );
        }
      })
    );
  }
}
