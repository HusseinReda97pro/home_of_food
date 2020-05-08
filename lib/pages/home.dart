import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/pages/tabs/home_tab.dart';
import 'package:home_of_food/pages/tabs/search_tap.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOnline = true;

 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer:AppDrawer(),
        appBar: MainAppBar(
          context: context,
        ),
        body: TabBarView(
          children: [
            HomePageTab(),
            SearchTab()
          ],
        ),
        bottomNavigationBar: Container(
          color: pink,
          child: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  color: lightBlue,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  color: lightBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
