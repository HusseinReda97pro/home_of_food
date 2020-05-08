import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(
      builder: (context, model, child) {
        return Scaffold(
          drawer: AppDrawer(),
          appBar: MainAppBar(
            context: context,
          ),
          body: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      model.currentUser.userName,
                      style: TextStyle(
                          color: black,
                          fontSize: 38,
                          fontWeight: FontWeight.w500),
                    ),
                    model.currentUser.fbLink == ''
                        ? Container()
                        : GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.0),
                              child: Image.asset(
                                'assets/icons/fb.png',
                                width: 45,
                                height: 45,
                              ),
                            ),
                            onTap: () {
                              // TODO open fp profile
                              print(model.currentUser.fbLink);
                            },
                          ),
                    Expanded(
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
              Text(model.currentUser.email,
                  style: TextStyle(color: black), textAlign: TextAlign.center),
              Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      border: Border.all(
                        color: black,
                      ),
                    ),
                    margin: EdgeInsets.all(20.0),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        //TODO add items number
                        Text(
                          'اجمالي عدد الوصفات : 0',
                          style: TextStyle(
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        //TODO add likes number
                        Text(
                          'اجمالي عدد الأعجابات : 0',
                          style: TextStyle(
                              color: black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: RaisedButton(
                  color: blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: black)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text(
                        'إضافة وصفة',
                        style: TextStyle(
                            color: black,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Icon(
                        Icons.add_box,
                        color: pink,
                        size: 30,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/add_item');
                  },
                ),
              ),
              
            ],
          ),
        );
      },
    );
  }
}
