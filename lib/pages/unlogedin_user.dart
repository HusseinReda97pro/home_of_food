import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';

class UnLogedinUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: MainAppBar(
        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.125),
            child: Icon(
              Icons.report_problem,
              size: MediaQuery.of(context).size.width * 0.7,
              color: Color(0XFFC5C5C5),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.16),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              'برجاء تسجيل الدخول أولاً لكي تتمكن من إضافة الوصفات او رؤية وصفات الأعضاء',
              style: TextStyle(
                  color: black, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25),
            child: RaisedButton(
              color: blue,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: black)),
              child: Row(
                children: <Widget>[
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.group_add,
                    color: pink,
                    size: 30,
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context,'/login');
              },
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
