import 'package:flutter/material.dart';
import 'package:home_of_food/widgets/columnbuilder/columnbuilder.dart';

class TestCard extends StatelessWidget {
  final String title;
  final List<String> ingredients;
  final List<String> preparation;
  final List<String> category;
  final String imageUrl;
  final String kitchen;
  final bool isOnline;

  TestCard(
      {this.title,
      this.imageUrl,
      this.ingredients,
      this.preparation,
      this.category,
      this.kitchen,
      this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          isOnline ? Image.network(imageUrl) : Image.asset(imageUrl),
          Text(kitchen, style: TextStyle(fontSize: 18)),
          Divider(),
          Text(
            'Ingredients',
            style: TextStyle(fontSize: 16),
          ),
          ColumnBuilder(
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              return Text(ingredients[index]);
            },
          ),
          Divider(),
          Text(
            'Preparation',
            style: TextStyle(fontSize: 16),
          ),
          ColumnBuilder(
            itemCount: preparation.length,
            itemBuilder: (context, index) {
              return Text(preparation[index]);
            },
          ),
          Divider(),
          Text(
            'Category',
            style: TextStyle(fontSize: 16),
          ),
          ColumnBuilder(
            itemCount: category.length,
            itemBuilder: (context, index) {
              return Text(category[index]);
            },
          ),
        ],
      ),
    );
  }
}
