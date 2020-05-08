import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/widgets/alert_message.dart';
import 'package:home_of_food/models/helpers/check_internet.dart';
import 'package:home_of_food/pages/auth/widgets/input_field.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final emailFocusNode = FocusNode();
  final fullNameFocusNode = FocusNode();
  final fbLinkFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController fbLinkController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, child) {
      return Scaffold(
        body: GestureDetector(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: CustomPaint(painter: CurvePainterHeader()),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.03,
                    child: Image.asset(
                      'assets/icons/logo.png',
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.12),
                child: model.signingup
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.33,
                            vertical:
                                MediaQuery.of(context).size.height * 0.18),
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            InputField(
                              hint: 'البريد الألكتروني',
                              controller: emailController,
                              focusNode: emailFocusNode,
                              isPassword: false,
                              validator: (value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                return emailValid
                                    ? null
                                    : 'البريد الألكتروني غير صالح';
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            InputField(
                              hint: 'الأسم بالكامل',
                              focusNode: fullNameFocusNode,
                              controller: fullNameController,
                              isPassword: false,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'الأسم مطلوب';
                                } else {
                                  if (value.length < 3)
                                    return 'يجب أن يكون الأسم أطول من ثلاثة أحرف';
                                  else {
                                    return null;
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            InputField(
                              hint: 'رابط حساب الفيس بوك (أختياري)',
                              focusNode: fbLinkFocusNode,
                              controller: fbLinkController,
                              isPassword: false,
                              validator: (_) {},
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            InputField(
                              hint: 'كلمة المرور',
                              focusNode: passwordFocusNode,
                              controller: passwordController,
                              isPassword: true,
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'يجب أن تكون كلمة السر أكثر من 6 أحرف';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            // Facebook
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                  side: BorderSide(color: black)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'التسجيل عن طريق الفيس بوك',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Image.asset(
                                    'assets/icons/fb.png',
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  )
                                ],
                              ),
                              color: Color(0XFF4267B2),
                              onPressed: () {
                                // TODO fb login
                              },
                            ),
                            // Google
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(50),
                                  side: BorderSide(color: black)),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'التسجيل عن طريق جوجل',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Image.asset(
                                    'assets/icons/google.png',
                                    fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,
                                  )
                                ],
                              ),
                              color: Colors.white,
                              onPressed: () {
                                // TODO google login
                              },
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Text('تمتلك حساب بالفعل؟'),
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 3.0),
                                    child: Text(
                                      'سجل الدخول',
                                      style: TextStyle(
                                          color: blue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  },
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
                      ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: CustomPaint(painter: CurvePainterBootom()),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.03,
                    bottom: MediaQuery.of(context).size.width * 0.03,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: black)),
                      child: Text(
                        'سجل الأن',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900),
                      ),
                      color: blue,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (await checkInternet()) {
                            var message = await model.signUp(
                                emailController.text,
                                passwordController.text,
                                fullNameController.text,
                                fbLinkController.text);
                            if (message != 'successfully') {
                              showAlertMessage(
                                  context: context,
                                  title: 'حدث خطًأ ما',
                                  message: message);
                            } else {
                              var message = await model.login(
                                emailController.text,
                                passwordController.text,
                              );
                              if (message != 'successfully') {
                                showAlertMessage(
                                    context: context,
                                    title: 'حدث خطًأ ما',
                                    message:
                                        'قد تم انشاء الحساب ولكن حدث خطأ عند تسجيل الدخول من فضلك حاول تجسيل الدخول مرة أخرى');
                              }
                              {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            }
                          } else {
                            showAlertMessage(
                                context: context,
                                title: 'حدث خطًأ ما',
                                message:
                                    'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      );
    });
  }
}

class CurvePainterHeader extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = pink;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    path.moveTo(0, size.height);
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

class CurvePainterBootom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = pink;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
        -size.width * 0.1, size.height * 0.3, 0, size.height);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    // path.lineTo(0,size.height* 0.6);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
//  Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         // color: pink,
//         child: SvgPicture.asset(
//           'assets/login.svg',
//           fit: BoxFit.scaleDown,
//         ),
//       ),
