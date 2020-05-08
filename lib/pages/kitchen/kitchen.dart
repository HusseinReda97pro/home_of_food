import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/data/categories_data.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/food_list/food_list.dart';
import 'package:home_of_food/pages/tabs/widgets/category_card.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:provider/provider.dart';

class KitchenPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> categories;
  KitchenPage({@required this.title, @required this.categories});
  Map<String, dynamic> checkIfCategoryExist(kitchen, category) {
    try {
      var cat = categoriesData.firstWhere(
          (e) => e['kitchen'] == kitchen && e['category'] == category);
      return {'exist': true, 'image_path': cat['image_path']};
    } catch (e) {
      return {'exist': false, 'image_path': 'NAN'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
      return Scaffold(
        drawer: AppDrawer(),
        appBar: MainAppBar(
          context: context,
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(25),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w900, color: black),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    ),
                scrollDirection: Axis.vertical,
                primary: false,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      child: CategoryCard(
                        title: categories[index]['categoryTitle'],
                        imagePath: categories[index]['image_path'],
                        kitchenTitile: title,
                      ),
                      onTap: () {
                        model.selectCategory(
                            category: categories[index]['categoryTitle'],
                            kitchen: title);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodList()));
                      });
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
