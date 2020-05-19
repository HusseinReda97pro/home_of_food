import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/food_list/widgets/food_list_card.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, chlild) {
      return Scaffold(
        drawer: AppDrawer(),
        appBar: MainAppBar(
          context: context,
        ),
        body: model.loadingFavorits
            ? Transform.rotate(
                angle: 9.43,
                child: ListSkeleton(
                  style: SkeletonStyle(
                    theme: SkeletonTheme.Light,
                    isShowAvatar: false,
                    barCount: 3,
                    colors: [Color(0xffcccccc), pink, Color(0xff333333)],
                    isAnimation: true,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: model.favoritesItems.length,
                itemBuilder: (context, index) {
                  FoodItem foodItem = FoodItem(
                    title: model.favoritesItems[index].title,
                    kitchen: model.favoritesItems[index].kitchen,
                    imagePath: model.favoritesItems[index].imagePath,
                    category: model.favoritesItems[index].category,
                    ingredients: model.favoritesItems[index].ingredients,
                    preparation: model.favoritesItems[index].preparation,
                  );
                  return FoodListCard(
                    foodItem: foodItem,
                  );
                }),
      );
    });
  }
}
