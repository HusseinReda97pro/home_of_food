import 'package:flutter/cupertino.dart';
import 'package:home_of_food/data/food_data.dart';

mixin CategoryModel on ChangeNotifier {
  List<Map<String, dynamic>> selectedCategoryItems = [];
  bool loadingCategory;

  void selectCategory({@required kitchen, @required category}) {
    loadingCategory = true;
    notifyListeners();
    selectedCategoryItems = foodData
        .where((e) =>
            e['kitchen'] == kitchen &&
            (e['category'] as List).contains(category))
        .toList();
    loadingCategory = false;
    notifyListeners();
  }
}
