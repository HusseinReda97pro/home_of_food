import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';

class DrawerTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  DrawerTab({this.icon, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: pink,
              size: 35,
            ),
            Container(
              margin: EdgeInsets.only(right: 5.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900, color: blue),
              ),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
