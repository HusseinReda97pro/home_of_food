import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/helpers/check_internet.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/info/send.dart';
import 'package:home_of_food/pages/profile/profile.dart';
import 'package:home_of_food/widgets/app_drawer/widgets/drawer_tab.dart';
import 'package:home_of_food/widgets/divider.dart';
import 'package:provider/provider.dart';

import '../alert_message.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(
      builder: (context, model, chlild) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: <Widget>[
                    Icon(Icons.format_align_justify),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'القائمة',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                elevation: Theme.of(context).platform == TargetPlatform.iOS
                    ? 0.0
                    : 4.0,
              ),
              DrawerTab(
                title: 'الصفحة الرئيسية',
                icon: Icons.home,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'المفضلات',
                icon: Icons.favorite,
                onTap: () {
                  model.getFavorites();
                  Navigator.pushNamed(context, '/favorits');
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'وصفات الأعضاء',
                icon: Icons.group,
                onTap: () async {
                  if (await checkInternet()) {
                    if (model.currentUser != null) {
                      model.getPosts();
                      Navigator.pushNamed(context, '/users_posts');
                    } else {
                      Navigator.pushNamed(context, '/unlogedin');
                    }
                  } else {
                    showAlertMessage(
                        context: context,
                        title: 'حدث خطًأ ما',
                        message: 'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                  }
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'الملف الشخصي',
                icon: Icons.person,
                onTap: () async {
                  if (await checkInternet()) {
                    if (model.currentUser != null) {
                      model.getProfilePosts(userUID: model.currentUser.userUID);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProfilePage(
                            myProfile: true,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pushNamed(context, '/unlogedin');
                    }
                  } else {
                    showAlertMessage(
                        context: context,
                        title: 'حدث خطًأ ما',
                        message: 'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                  }
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'حول التطبيق',
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'الإبلاغ عن مشكلة',
                icon: Icons.report_problem,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Send(Message.Issue)));
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'إرسال رأيك في التطبيق',
                icon: Icons.mail,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              Send(Message.FeadBack)));
                },
              ),
              DividerV2(),
              DrawerTab(
                title: 'تسجيل الخروج',
                icon: Icons.exit_to_app,
                onTap: () async {
                  if (model.currentUser == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            titlePadding: EdgeInsets.all(0.0),
                            title: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'حدث خطًأ ما!!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              color: pink,
                            ),
                            content: Text(
                              'أنت لم تسجل الدخول',
                              style: TextStyle(color: black),
                            ),
                            actions: <Widget>[
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                color: pink,
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'حسنا',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          );
                        });
                  } else {
                    try {
                      await FirebaseAuth.instance.signOut();
                      model.logout();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              titlePadding: EdgeInsets.all(0.0),
                              title: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'تم بنجاح',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                color: pink,
                              ),
                              content: Text(
                                'تم تسجيل الخروج بنجاح',
                                style: TextStyle(color: black),
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  color: pink,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  },
                                  child: Text(
                                    'حسنا',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          });
                    } catch (_) {}
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
