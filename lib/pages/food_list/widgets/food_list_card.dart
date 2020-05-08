import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:home_of_food/pages/food_item/food_item.dart';

class FoodListCard extends StatelessWidget {
  final FoodItem foodItem;
  FoodListCard({this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
                vertical: MediaQuery.of(context).size.height * 0.02),
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
            decoration: BoxDecoration(
              color: lightBlue,
              border: Border.all(color: Color(0XFF707070)),
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Text(
                foodItem.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: pink,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.03,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0XFF707070)),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/kitchens/' + foodItem.kitchen.split(' ')[0] + '.jpg',
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.025,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0XFF707070)),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              child: ClipOval(
                child: FadeInImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/home-of-food.appspot.com/o/food_imges%2F' +
                          foodItem.imagePath.split(
                              '/')[foodItem.imagePath.split('/').length - 1] +
                          '?alt=media'),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/placeholder_image.png'),
                ),
              ),
            ),

            //  ClipOval(
            //   // TODO hanel ofline
            //   child: Image.network(
            // 'https://firebasestorage.googleapis.com/v0/b/home-of-food.appspot.com/o/food_imges%2F' +
            //     imagePath.split('/')[imagePath.split('/').length - 1] +
            //     '?alt=media',
            //     width: 60,
            //     fit: BoxFit.cover,

            //   ),
            // ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    FoodItemPage(foodItem: foodItem)));
      },
    );
  }
}
