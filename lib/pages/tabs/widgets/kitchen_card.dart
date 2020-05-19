import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/data/categories_data.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/food_list/food_list.dart';
import 'package:home_of_food/pages/kitchen/kitchen.dart';
import 'package:home_of_food/pages/tabs/widgets/category_card.dart';
import 'package:home_of_food/widgets/rowbuilder/rowbuilder.dart';
import 'package:provider/provider.dart';

class KitchenCard extends StatelessWidget {
  final String title;

  KitchenCard({this.title});
  final List<String> categories = [
    'حلويات رمضان',
    'تشيز كيك',
    'وصفات طبخ',
    'فطور رمضان',
    'مقبلات رمضان',
    'وصفات الخبز',
    'تغذية الطفل',
    'السلطات',
    'وصفات رمضانية',
    'مكرونة وباستا',
    'البيتزا',
    'رجيم رمضان',
    'شوربات رمضان',
    'مشروبات وعصائر',
    'وصفات دجاج',
    'ساندويشات باردة',
    'اكلات لحم',
    'كيك',
    'ساندويشات ساخنة',
    'مشروبات',
    'السندويشات',
    'أكلات رجيم',
    'معجنات',
    'حلى سهل',
    'عصائر رمضان',
    'بيتزا',
    'سحور رمضان',
    'وصفات فطور',
    'الشوربة',
    'أكلات اللحوم',
    'حلويات',
    'أكلات مرضى السكري',
    'المقبلات',
    'أطباق الخضار',
    'حلويات باردة',
    'صلصات',
    'أطباق الأسماك وثمار البحر'
  ];
  Map<String, dynamic> checkIfCategoryExist(kitchen, category) {
    try {
      var cat = categoriesData.firstWhere(
          (e) => e['kitchen'] == kitchen && e['category'] == category);
      return {'exist': true, 'image_path': cat['image_path']};
    } catch (e) {
      return {'exist': false, 'image_path': 'NAN'};
    }
  }

  final List<Map<String, dynamic>> cats = [];

  @override
  Widget build(BuildContext context) {
    for (var cat in categories) {
      var categoryData = checkIfCategoryExist(title, cat);
      if (categoryData['exist']) {
        cats.add({
          'categoryTitle': cat,
          'image_path': categoryData['image_path'],
        });
      }
    }

    return Consumer<MainModel>(builder: (context, model, child) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(3.0),
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => KitchenPage(
                          title: title,
                          categories: cats,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RowBuilder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var cat = checkIfCategoryExist(title, categories[index]);
                  if (cat['exist']) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        child: CategoryCard(
                          title: categories[index],
                          imagePath: cat['image_path'],
                          kitchenTitile: title,
                          // imagePath: 'assets/placeholder_image.png',
                        ),
                        onTap: () {
                          
                          model.selectCategory(
                              category: categories[index], kitchen: title);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodList()));
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
