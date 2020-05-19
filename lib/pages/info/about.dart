import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/curve_painter_bottom.dart';
import 'package:home_of_food/widgets/curve_painter_header.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  final sendMail = TapGestureRecognizer()
    ..onTap = () async {
      final url = 'mailto:pro.hussein.reda@gmail.com';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch';
      }
    };
  final upworkProfilePage = TapGestureRecognizer()
    ..onTap = () async {
      final url = 'https://www.upwork.com/freelancers/~01329937a2178fc839';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch';
      }
    };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: MainAppBar(context: context,),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: CustomPaint(painter: CurvePainterHeader()),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'جميع الوصفات الواردة بالتطبيق ما هي الا تجميع لوصفات طبخ من اشهر مواقع الوصفات ( مثل موقع مطبخ سيدتي ) ولكن دون الحاجة للاتصال بالإنترنت',
                style: TextStyle(color: black, fontSize: 18),
                textAlign: TextAlign.center,
              )),
          Divider(),
          
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'all rights reserved @ 2020 for Hussein Reda who developed this app.',
                  style: TextStyle(color: black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                Text.rich(
                  TextSpan(
                      text: 'you can contact me by email',
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Pro.hussein.reda@gmail.com ',
                            style: TextStyle(
                                color: blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                            recognizer: sendMail),
                        TextSpan(
                          text: ' or my ',
                          style: TextStyle(color: black, fontSize: 18),
                        ),
                        TextSpan(
                            text: ' upwork ',
                            style: TextStyle(
                                color: blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                            recognizer: upworkProfilePage),
                        TextSpan(
                          text: ' account ',
                          style: TextStyle(color: black),
                        ),
                        TextSpan(
                          text: ' if you need me for a freelance job. ',
                          style: TextStyle(color: black),
                        ),
                      ]),
                  style: TextStyle(color: black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: CustomPaint(painter: CurvePainterBottom()),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.red;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
