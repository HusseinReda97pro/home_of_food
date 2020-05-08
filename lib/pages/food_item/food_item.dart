import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:home_of_food/models/post.dart';
import 'package:home_of_food/pages/food_item/widgets/image_card.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/columnbuilder/columnbuilder.dart';
import 'package:home_of_food/widgets/divider.dart';
import 'package:home_of_food/widgets/rowbuilder/rowbuilder.dart';

class FoodItemPage extends StatelessWidget {
  final FoodItem foodItem;
  final Post post;
  FoodItemPage({this.foodItem, this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: MainAppBar(
        context: context,
      ),
      body: ListView(
        children: <Widget>[
          FoodItemImageCard(
            imagePath: post == null ? foodItem.imagePath : null,
            imageURL: post == null ? null : post.imageURL,
            title: post == null ? foodItem.title : post.title,
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'المطبخ:',
                  style: TextStyle(
                      color: blue, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    post == null ? foodItem.kitchen : post.title,
                    style: TextStyle(
                        color: black,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(child: SizedBox()),
                // TODO edit for favorite items
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.favorite_border,
                    color: pink,
                    size: 38,
                  ),
                ),
              ],
            ),
          ),
          DividerV2(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Text(
                  'التصنيف:',
                  style: TextStyle(
                      color: blue, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: RowBuilder(
                        itemCount: post == null
                            ? foodItem.category.length
                            : [post.category].length,
                        itemBuilder: (context, index) {
                          if (post == null) {
                            if (index < foodItem.category.length - 1) {
                              foodItem.category[index] += ", ";
                            }
                          }
                          return Text(
                            post == null
                                ? foodItem.category[index]
                                : post.category,
                            style: TextStyle(
                                color: black,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // المقادير
          DividerV2(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              'المقادير:',
              style: TextStyle(
                  color: blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline),
            ),
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: blue.withOpacity(0.1),
                blurRadius: 20.0,
              ),
            ]),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: ColumnBuilder(
                  itemCount: post == null
                      ? foodItem.ingredients.length
                      : post.ingredients.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: Row(children: <Widget>[
                        Transform.rotate(
                          angle: 29.8,
                          child: Icon(
                            Icons.navigation,
                            color: black,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              post == null
                                  ? foodItem.ingredients[index]
                                  : post.ingredients[index],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ),
          ),
          // خطوات التحضير
          DividerV2(),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              'خطوات التحضير:',
              style: TextStyle(
                  color: blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline),
            ),
          ),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: blue.withOpacity(0.1),
                blurRadius: 20.0,
              ),
            ]),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: ColumnBuilder(
                  itemCount: post == null
                      ? foodItem.preparation.length
                      : post.preparation.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Transform.rotate(
                              angle: 29.8,
                              child: Icon(
                                Icons.navigation,
                                color: black,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                post == null
                                    ? foodItem.preparation[index]
                                    : post.preparation[index],
                                overflow: TextOverflow.clip,
                                maxLines: 5,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ]),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                margin: EdgeInsets.all(5.0),
                child: RaisedButton(
                  color: blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: black)),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'مشاركة الوصفة',
                        style: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Icon(
                        Icons.screen_share,
                        color: pink,
                        size: 30,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  onPressed: () {
                    // TODO for share item
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
