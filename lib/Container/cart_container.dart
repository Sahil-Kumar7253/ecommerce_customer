import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cartModel.dart';
import '../providers/cart_provider.dart';
import '../views/specific_Product.dart';

class CartContainer extends StatefulWidget {
  final String image,name,productId;
  final int new_price,old_price,maxQuantity,selectedQuantity;

  const CartContainer({
    super.key,
    required this.image,
    required this.name,
    required this.productId,
    required this.new_price,
    required this.old_price,
    required this.maxQuantity,
    required this.selectedQuantity,
  });

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;

  increaseCount(int max) async{
    if(count >= max){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Maximum Quantity Reached")));
      return ;
    }else{
      Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(productId: widget.productId , quantity: count));
    }
    setState(() {
      count++;
    });
  }

  decreaseCount() async{
    if(count > 1) {
      Provider.of<CartProvider>(context, listen: false).decreaseQuantity(
          widget.productId);
      setState(() {
        count--;
      });
    }
  }

  @override
  void initState() {
    count = widget.selectedQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.network(widget.image),
                  ),
                SizedBox(width:10),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                          child: Text(
                            widget.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          )
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          SizedBox(width: 2),
                          Text(
                            "₹${widget.old_price.toString()}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "₹${widget.new_price.toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "${discountPercent(widget.old_price, widget.new_price)}%",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ),
                IconButton(
                    onPressed: (){
                      Provider.of<CartProvider>(context , listen: false).deleteItemFromCart(widget.productId);
                    },
                    icon: Icon(Icons.delete, color: Colors.red)
                )
              ]
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Quantity : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    decreaseCount();
                    setState(() {});
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.remove, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 15),
                Text("${widget.selectedQuantity}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: (){
                    increaseCount(widget.maxQuantity);
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(Icons.add, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 8),
                Spacer(),
                Text("Total : ₹${widget.new_price * count}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

              ],
            )
          ],
        ),
      ),
    );
  }
}
