import 'package:flutter/material.dart';

class FoodItemImageCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String imageURL;
  FoodItemImageCard({this.imagePath, this.title, this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FadeInImage(
          image: NetworkImage(imagePath == null
              ? imageURL
              : 'https://firebasestorage.googleapis.com/v0/b/home-of-food.appspot.com/o/food_imges%2F' +
                  imagePath.split('/')[imagePath.split('/').length - 1] +
                  '?alt=media'),
          width: MediaQuery.of(context).size.width,
          height: 250,
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/placeholder_image.png'),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(5),
            color: Colors.black.withOpacity(0.3),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
