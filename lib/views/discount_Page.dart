import 'package:flutter/material.dart';

import '../controllers/db_service.dart';
import '../models/CouponModel.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Page'),
      ),
      body: StreamBuilder(
          stream: DbService().readDiscount(),
          builder: (context , snapshot){
            if(snapshot.hasData){
              List<CouponModel> coupons = CouponModel.fromJsonList(snapshot.data!.docs);

              if(coupons.isEmpty){
                return SizedBox();
              }else{
                return ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context , index){
                    return ListTile(
                      leading: Icon(Icons.discount),
                      title: Text(coupons[index].code),
                      subtitle: Text(coupons[index].desc),
                    );
                  },
                );
              }
            }else{
              return CircularProgressIndicator();
            }
          }
      ),
    );
  }
}
