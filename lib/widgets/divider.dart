import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';

class DividerV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: lightBlue,
      height: 2.0,
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1, vertical: 4.0),
      child: Divider(
        color: lightBlue,
      ),
    );
  }
}
