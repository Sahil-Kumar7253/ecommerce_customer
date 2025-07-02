import 'package:ecommerce_customer/controllers/db_service.dart';
import 'package:ecommerce_customer/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
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
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: category
                      .map((cat) => CategoryButton(imagepath: cat.image, name: cat.name))
                      .toList()
                  ,
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

class CategoryButton extends StatefulWidget {
  final String imagepath, name;
  const CategoryButton({
    super.key,
    required this.imagepath,
    required this.name
  });

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      height: 140,
      width: 120,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300,width: 4),
          borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(widget.imagepath,height: 80),
          SizedBox(height: 8),
          Text(
              "${widget.name.substring(0,1).toUpperCase()}${widget.name.substring(1)}"
          )
        ],
      ),
    );
  }
}

