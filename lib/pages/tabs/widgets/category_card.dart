import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/data/food_data.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String kitchenTitile;
  final String imagePath;

  CategoryCard({this.title, this.imagePath, this.kitchenTitile});

  List<Map<String, dynamic>> selectCategory(kitchen, category) {
    var categoryItems = foodData.where((e) =>
        e['kitchen'] == kitchen && (e['category'] as List).contains(category));
    return categoryItems.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width,
            height: 250,
            fit: BoxFit.fill,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: lightPink,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                ),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
