import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/models/productsModel.dart';
import 'package:flutter/material.dart';

class SpecificProduct extends StatefulWidget {
  const SpecificProduct({super.key});

  @override
  State<SpecificProduct> createState() => _SpecificProductState();
}

class _SpecificProductState extends State<SpecificProduct> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text("${args["name"].substring(0,1).toUpperCase()}${args["name"].substring(1)}"),
      ),
      body: StreamBuilder(
          stream: DbService().readProductByCategory(args["name"]),
          builder: (context , snapshot){
            if(snapshot.hasData){
              List<Productsmodel> products = Productsmodel.fromSnapshotList(snapshot.data!.docs);
              if(products.isEmpty){
                return Center(child: Text("No Product Available"));
              }else{
               return GridView.builder(
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                     crossAxisSpacing: 0,
                     mainAxisSpacing: 4
                   ),
                   itemCount: products.length,
                   itemBuilder: (content, index){
                     final product = products[index];
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: GestureDetector(
                         onTap: (){
                           Navigator.pushNamed(
                               context,
                               '/viewproduct',
                               arguments: product
                           );
                         },
                         child: Card(
                           color: Colors.grey.shade100,
                           child: Column(
                             children: [
                               Expanded(
                                 child: Container(
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius: BorderRadius.circular(20),
                                       image: DecorationImage(
                                           image: NetworkImage(product.image),
                                           fit: BoxFit.fitHeight
                                       )
                                   ),
                                 ),
                               ),
                               SizedBox(height: 8),
                               Text(
                                 product.name,
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                                 style: TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.w600
                                 ),
                               ),
                               SizedBox(height: 8),
                               Row(
                                 children: [
                                   SizedBox(width: 2),
                                   Text(
                                     "₹${product.old_Price}",
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w600,
                                       decoration: TextDecoration.lineThrough,
                                     ),
                                   ),
                                   SizedBox(width: 4),
                                   Text(
                                     "₹${product.new_Price}",
                                     style: TextStyle(
                                         fontSize: 14,
                                         fontWeight: FontWeight.w600,
                                         color: Colors.black
                                     ),
                                   ),
                                   SizedBox(width: 2),
                                   Icon(Icons.arrow_downward,color: Colors.green),
                                   Text(
                                     "${discountPercent(product.old_Price, product.new_Price)}%",
                                     style: TextStyle(
                                       fontSize: 14,
                                       fontWeight: FontWeight.w500,
                                       color: Colors.green,
                                     ),
                                   )
                                 ],
                               )
                             ],
                           ),
                         ),
                       ),
                     );
                   }
               );
              }
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}

String discountPercent(int oldPrice,int newPrice){
  if(oldPrice == 0){
    return "0";
  }
  else{
    double percentage = ((oldPrice - newPrice) / oldPrice * 100);
    return percentage.toInt().toString();
  }
}