import 'package:ecommerce_customer/Container/bannerContainer.dart';
import 'package:ecommerce_customer/Container/zoneContainer.dart';
import 'package:ecommerce_customer/models/PromoModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/db_service.dart';
import '../models/categories_model.dart';
import 'category_Container.dart';

class HomePageMakerContainer extends StatefulWidget {
  const HomePageMakerContainer({super.key});

  @override
  State<HomePageMakerContainer> createState() => _HomePageMakerContainerState();
}

class _HomePageMakerContainerState extends State<HomePageMakerContainer> {
  int min = 0;
  minCalculator(int a,int b){
   return min = a>b?b:a;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().readCategory(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            List<CategoriesModel> category = CategoriesModel.fromJsonList(snapshot.data!.docs);
            if(category.isEmpty){
              return SizedBox();
            }else{
              return StreamBuilder(
                  stream: DbService().readBanner(),
                  builder: (context, bannerSnapshot){
                    if(bannerSnapshot.hasData){
                      List<PromoBannersModel> banners = PromoBannersModel.fromJsonList(snapshot.data!.docs);
                      if(banners.isEmpty){
                        return SizedBox();
                      }else{
                        return Column(
                          children: [
                            for(int i = 0; i < minCalculator(snapshot.data!.docs.length, bannerSnapshot.data!.docs.length); i++)
                              Column(
                                children: [
                                  ZoneContainer(category: snapshot.data!.docs[i]["name"]),
                                  BannerContainer(image: bannerSnapshot.data!.docs[i]["image"], category: bannerSnapshot.data!.docs[i]["category"])
                                ],
                              )
                          ],
                        );
                      }
                    }else{
                      return SizedBox();
                    }
                  }
              );
            }
          }else{
            return Shimmer(gradient: LinearGradient(colors: [Colors.grey.shade200,Colors.white]), child: Container(width: double.infinity,height: 400));
          }
        }
    );
  }
}
