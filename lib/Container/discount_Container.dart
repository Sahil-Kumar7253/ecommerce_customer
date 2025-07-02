import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/models/CouponModel.dart';
import 'package:flutter/material.dart';

class DiscountContainer extends StatefulWidget {
  const DiscountContainer({super.key});

  @override
  State<DiscountContainer> createState() => _DiscountContainerState();
}

class _DiscountContainerState extends State<DiscountContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().readDiscount(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            List<CouponModel> coupons = CouponModel.fromJsonList(snapshot.data!.docs);

            if(coupons.isEmpty){
              return SizedBox();
            }else{
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/discountpage');
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16,vertical: 18),
                  margin: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Use Coupon : ${coupons[0].code}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900
                        ),
                      ),
                      Text(
                        coupons[0].desc,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.shade900
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }else{
            return CircularProgressIndicator();
          }
        }
    );
  }
}
