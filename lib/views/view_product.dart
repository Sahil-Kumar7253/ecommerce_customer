import 'package:ecommerce_customer/views/specific_Product.dart';
import 'package:flutter/material.dart';

import '../models/productsModel.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final argumnets =
        ModalRoute.of(context)!.settings.arguments as Productsmodel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              argumnets.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    argumnets.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Rs ${argumnets.old_Price.toString()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Rs ${argumnets.new_Price.toString()}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_downward, color: Colors.green, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "${discountPercent(argumnets.old_Price, argumnets.new_Price)}%",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  argumnets.maxQuantity == 0
                      ? Text(
                        "Out of Stock",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      )
                      : Text(
                        "only ${argumnets.maxQuantity} left",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                  SizedBox(height: 10),
                  Text(argumnets.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * .5,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade500,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(),
              ),
              child: Text("Add To Cart"),
            ),
          ),
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width * .5,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue.shade500,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(),
              ),
              child: Text("Buy Now"),
            ),
          ),
        ],
      ),
    );
  }
}
