import 'dart:math';

import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/views/specific_Product.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../models/productsModel.dart';

class ZoneContainer extends StatefulWidget {
  final String category;

  const ZoneContainer({super.key, required this.category});

  @override
  State<ZoneContainer> createState() => _ZoneContainerState();
}

class _ZoneContainerState extends State<ZoneContainer> {

  Widget specialQuote({required int price,required int dis}){
    int random = Random().nextInt(2);

    List<String> quotes = [
      "Starting at ₹$price",
      "Get upto ₹$dis off",
    ];

    return Text(quotes[random],style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.green));
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().readProductByCategory(widget.category),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List<Productsmodel> products = Productsmodel.fromSnapshotList(snapshot.data!.docs);
            if(products.isEmpty){
              return Center(child: Text("No Product Available"));
            }else{
             return Container(
               padding: EdgeInsets.symmetric(horizontal: 10),
               color: Colors.grey.shade50,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text("${widget.category.substring(0,1).toUpperCase()}${widget.category.substring(1)}"),
                       Spacer(),
                       IconButton(
                           onPressed: (){
                              Navigator.pushNamed(
                                context,
                                "/specific",
                                arguments: {"name" : widget.category}
                              );
                           },
                           icon: Icon(Icons.chevron_right)
                       )
                     ],
                   ),
                   Wrap(
                     spacing: 4,
                     children: [
                       for(int i = 0; i < (products.length>4?4:products.length); i++)
                         GestureDetector(
                           onTap: (){
                             Navigator.pushNamed(
                                 context,
                                 '/viewproduct',
                                 arguments: products[i]
                             );
                           },
                           child: Container(
                             width: MediaQuery.sizeOf(context).width*.43,
                             padding: EdgeInsets.all(8),
                             margin: EdgeInsets.all(5),
                             decoration: BoxDecoration(
                                 border: Border.all(color: Colors.grey.shade300,width: 4),
                                 borderRadius: BorderRadius.circular(4),
                             ),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Center(child: Image.network(products[i].image,height: 120)),
                                 Text(products[i].name,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),
                                 specialQuote(price: products[i].new_Price, dis: int.parse(discountPercent(products[i].old_Price, products[i].new_Price)))
                               ],
                             ),
                           ),
                         )
                     ],
                   )
                 ],
               ),
             );
            }
          }else{
            return Shimmer(gradient: LinearGradient(colors: [Colors.grey.shade200,Colors.white]), child: Container(width: double.infinity,height: 90));
          }
        }
    );
  }
}
