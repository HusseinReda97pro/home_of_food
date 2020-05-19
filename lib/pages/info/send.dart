import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/helpers/check_internet.dart';
import 'package:home_of_food/widgets/alert_message.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/curve_painter_bottom.dart';
import 'package:home_of_food/widgets/curve_painter_header.dart';
import 'package:home_of_food/widgets/ensure_visible.dart.dart';
import 'package:home_of_food/widgets/loading.dart';

enum Message { FeadBack, Issue }

class Send extends StatefulWidget {
  final Message messageType;
  Send(this.messageType);
  @override
  State<StatefulWidget> createState() {
    return _SendState();
  }
}

class _SendState extends State<Send> {
  FocusNode _messageFocusNode = FocusNode();
  TextEditingController _messageController = TextEditingController();

  Future<bool> send(message) async {
    final Map<String, dynamic> messageMap = {'message': message};
    try {
      FirebaseDatabase database = FirebaseDatabase.instance;
      await database
          .reference()
          .child(widget.messageType == Message.FeadBack ? 'FeadBack' : 'Issue')
          .push()
          .set(messageMap);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: MainAppBar(
        context: context,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: CustomPaint(painter: CurvePainterHeader()),
            ),
            SizedBox(height: 15,),
            EnsureVisibleWhenFocused(
              focusNode: _messageFocusNode,
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  controller: _messageController,
                  minLines: 6,
                  maxLines: 8,
                  decoration: InputDecoration(
                      hintText: widget.messageType == Message.FeadBack
                          ? 'ما رسالتك'
                          : 'ما مشكلتك',
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.33),
              child: RaisedButton(
                color: blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: black)),
                child: Row(
                  children: <Widget>[
                    Text(
                      'إرسال',
                      style: TextStyle(color: black, fontSize: 22),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Icon(
                      Icons.send,
                      color: pink,
                    ),
                  ],
                ),
                onPressed: () async {
                  if (_messageController.text.length > 0) {
                    if (await checkInternet()) {
                      loading(context, 'جاري ارسال رسالتك');
                      bool sended = await send(_messageController.text);
                      Navigator.pop(context);
                      if (sended) {
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
                                  'تم ارسال رسالتك بنجاح',
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
                      } else {
                        showAlertMessage(
                            context: context,
                            title: 'حدث خطًأ ما',
                            message: 'حدث خطأ لم يتم ارسال رسالتك');
                      }
                    } else {
                      showAlertMessage(
                          context: context,
                          title: 'حدث خطًأ ما',
                          message: 'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                    }
                  } else {
                    showAlertMessage(
                        context: context,
                        title: 'حدث خطًأ ما',
                        message: 'قم بإدخال رسالتك');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: CustomPaint(painter: CurvePainterBottom()),
      ),
    );
  }
}
