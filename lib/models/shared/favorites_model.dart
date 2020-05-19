import 'package:flutter/cupertino.dart';
import 'package:home_of_food/data/food_data.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin FavoritesModel on ChangeNotifier {
  List<FoodItem> favoritesItems = [];
  List<String> imagePaths = [];
  bool loadingFavorits;

  Future<void> addToFavorites(imagePath) async {
    favoritesItems.add(await getItem(imagePath));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imagePaths.add(imagePath);
    prefs.setStringList("favorites", imagePaths);
    notifyListeners();
  }

  Future<void> deleteFromFavorites(imagePath) async {
    favoritesItems.removeWhere((item) {
      return item.imagePath == imagePath;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imagePaths.remove(imagePath);
    prefs.setStringList("favorites", imagePaths);
    notifyListeners();
  }

  Future<void> getPaths() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    imagePaths = prefs.getStringList("favorites") == null
        ? []
        : prefs.getStringList("favorites").toList();
  }

  void getFavorites() async {
    loadingFavorits = true;
    favoritesItems.clear();
    notifyListeners();
    for (var item in imagePaths) {
      favoritesItems.add(await getItem(item));
    }
    loadingFavorits = false;
    notifyListeners();
  }

  Future<FoodItem> getItem(imagePath) async {
    var item = foodData.firstWhere((e) => e['image_path'] == imagePath);

    FoodItem foodItem = FoodItem(
        title: item['title'],
        category: item['category'],
        kitchen: item['kitchen'],
        imagePath: item['image_path'],
        ingredients: item['ingredients'],
        preparation: item['preparation']);
    return foodItem;
  }
}
