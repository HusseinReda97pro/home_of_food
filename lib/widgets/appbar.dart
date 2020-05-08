import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final context;
  MainAppBar({@required this.context});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          Expanded(child: SizedBox()),
          Text(
            'Hom of food',
            style: TextStyle(color: lightBlue, fontSize: 24),
          ),
          Expanded(child: SizedBox()),
          Image.asset(
            'assets/icons/logo.png',
            height: MediaQuery.of(context).size.height * 0.07,
          )
        ],
      ),
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize =>
      new Size.fromHeight(MediaQuery.of(context).size.height * 0.09);
}
