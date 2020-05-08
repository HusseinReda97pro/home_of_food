import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;
  RoundedButton({this.icon, this.color, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3.0,
      color: color,
      borderRadius: BorderRadius.circular(50.0),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 12.0,
        height: 24.0,
        child: Icon(
          icon,
          color: pink, 
          size: 18,          
        ),
      ),
    );
  }
}
