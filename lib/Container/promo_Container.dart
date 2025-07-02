import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/models/PromoModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().readPromo(),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            List<PromoBannersModel> promos = PromoBannersModel.fromJsonList(snapshot.data!.docs);
            if(promos.isEmpty){
              return SizedBox();
            }
            else{
              return CarouselSlider(
                items: promos.map((promo) => Image.network(promo.image , fit: BoxFit.cover,)).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  aspectRatio:16/8,
                  viewportFraction: 1,
                  scrollDirection: Axis.horizontal,
                  enlargeCenterPage: true,
                ),
              );
            }
          }
          else{
            return Shimmer(gradient: LinearGradient(colors: [Colors.grey.shade200,Colors.white]), child: Container(width: double.infinity,height: 300));
          }
        }
    );
  }
}
