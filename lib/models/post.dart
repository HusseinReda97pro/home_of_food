
import 'package:flutter/material.dart';

class Post{

  final String postID;
  final String title;
  final String userUID;
  final String category;
  final String kitchen;
  final String userName;
  final List<dynamic> ingredients;
  final List<dynamic> preparation;
  final String imageURL;
  List<dynamic> likedList;

  Post({
    @required this.postID,
    @required this.title,
    @required this.userUID,
    @required this.userName,
    @required this.category,
    @required this.kitchen,
    @required this.ingredients,
    @required this.preparation,
    @required this.imageURL,
    @required this.likedList,
  });

}