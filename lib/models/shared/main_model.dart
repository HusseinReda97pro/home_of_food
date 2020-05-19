import 'package:flutter/material.dart';
import 'package:home_of_food/models/shared/category_model.dart';
import 'package:home_of_food/models/shared/favorites_model.dart';
import 'package:home_of_food/models/shared/user_model.dart';
import 'package:home_of_food/models/shared/users_posts_model.dart';


class MainModel extends ChangeNotifier
    with UserModel, PostsModel, CategoryModel,FavoritesModel {}
