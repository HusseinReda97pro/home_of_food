import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/helpers/check_internet.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/posts/posts_list/posts_list.dart';
import 'package:home_of_food/widgets/alert_message.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final bool myProfile;
  final String title;
  ProfilePage({this.myProfile, this.title});
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  void editFbLink({context, title, fbLink, model}) {
    TextEditingController linkController = TextEditingController();
    linkController.text = fbLink ?? '';
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
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: pink,
            ),
            content: TextField(
              controller: linkController,
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: pink,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'الغاء',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: pink,
                  child: Text(
                    fbLink == null ? 'إضافة' : 'تغيير',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (await checkInternet()) {
                      if (linkController.text.length > 5) {
                        loading(
                          context,
                          'جاري تحديث الرابط',
                        );
                        bool updated =
                            await model.addFBLink(linkController.text.trim());
                        if (updated) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                    'تم تغيير رابط الفيس بوك',
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
                        }
                      }
                    } else {
                      showAlertMessage(
                          context: context,
                          title: 'حدث خطًأ ما',
                          message: 'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                    }
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(
      builder: (context, model, child) {
        return Scaffold(
          drawer: AppDrawer(),
          appBar: MainAppBar(
            context: context,
          ),
          body: model.loadingProfile
              ? Transform.rotate(
                  angle: 9.43,
                  child: ListSkeleton(
                    style: SkeletonStyle(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: false,
                      barCount: 3,
                      colors: [Color(0xffcccccc), pink, Color(0xff333333)],
                      isAnimation: true,
                    ),
                  ),
                )
              : ListView(
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
                          widget.myProfile
                              ? GestureDetector(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.0),
                                    child: Image.asset(
                                      'assets/icons/fb.png',
                                      width: 45,
                                      height: 45,
                                    ),
                                  ),
                                  onTap: () {
                                    editFbLink(
                                        context: context,
                                        title: 'رابط الفيس بوك',
                                        fbLink: model.currentUser.fbLink,
                                        model: model);
                                  },
                                )
                              : model.anotherUserfbLink == null
                                  ? Container()
                                  : GestureDetector(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        child: Image.asset(
                                          'assets/icons/fb.png',
                                          width: 45,
                                          height: 45,
                                        ),
                                      ),
                                      onTap: () async {
                                        if (await canLaunch(
                                            model.anotherUserfbLink)) {
                                          await launch(model.anotherUserfbLink);
                                        } else {
                                          throw 'Could not launch';
                                        }
                                      },
                                    ),
                          Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    widget.myProfile
                        ? Text(model.currentUser.email,
                            style: TextStyle(color: black),
                            textAlign: TextAlign.center)
                        : Container(),
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
                              Text(
                                'اجمالي عدد الوصفات : ' +
                                    model.profilePosts.length.toString(),
                                style: TextStyle(
                                    color: black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'اجمالي عدد الأعجابات : ' +
                                    model.totalLieks.toString(),
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
                    widget.myProfile
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03),
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
                                Navigator.pushReplacementNamed(
                                    context, '/add_item');
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.only(
                          top: 10.0,
                          bottom: 10,
                          right: 15,
                          left: MediaQuery.of(context).size.width * 0.70),
                      child: Text(
                        widget.myProfile ? 'وصفاتك :' : 'الوصفات :',
                        style: TextStyle(
                            color: blue,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    PostList(
                      posts: model.profilePosts,
                    )
                  ],
                ),
        );
      },
    );
  }
}
