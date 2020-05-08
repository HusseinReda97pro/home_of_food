import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/data/categories.dart';
import 'package:home_of_food/data/kitchens.dart';
import 'package:home_of_food/models/firebase/upload_image.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/auth/widgets/input_field.dart';
import 'package:home_of_food/widgets/RoundedButton.dart';
import 'package:home_of_food/widgets/alert_message.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/columnbuilder/columnbuilder.dart';
import 'package:home_of_food/widgets/divider.dart';
import 'package:home_of_food/widgets/ensure_visible.dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:home_of_food/models/helpers/check_internet.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddItemState();
  }
}

class AddItemState extends State<AddItem> {
  TextEditingController titleController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController preparationController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  FocusNode ingredientsFocusNode = FocusNode();
  FocusNode preparationFocusNode = FocusNode();
  String selectedKitchen = 'المطبخ';
  String selectedCategory = 'التصنيف';
  File foodImage;
  List<String> ingredients = [];
  List<String> preparation = [];
  bool isLooding = false;

  void _getImage(BuildContext context, ImageSource source) {
    try {
      ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
        Navigator.pop(context);
        setState(() {
          foodImage = image;
        });
        print(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'أختار صورة',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: black,
                      fontSize: 16.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.camera,
                              color: pink,
                              size: 30,
                            ),
                            Text(
                              'أستخدام الكاميرا',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: pink,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        onTap: () {
                          _getImage(context, ImageSource.camera);
                        },
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.photo_library, color: pink, size: 30),
                          Text(
                            'أستخدام معرض الصور',
                            style: TextStyle(
                                fontSize: 18,
                                color: pink,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      onTap: () {
                        _getImage(context, ImageSource.gallery);
                      },
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget input({focusNode, controller, hint}) {
    return Container(
      margin: EdgeInsets.only(right: 3.0),
      height: 40,
      width: MediaQuery.of(context).size.width * 0.7,
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),
              borderSide: BorderSide(color: black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
              borderSide: BorderSide(color: black),
            ),
          ),
        ),
      ),
    );
  }

  void loading(contextm, message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            titlePadding: EdgeInsets.all(0.0),
            content: Container(
              width: 150,
              height: 100,
              child: Column(
                children: <Widget>[
                  SpinKitChasingDots(
                    color: pink,
                    size: 50.0,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: pink, fontSize: 16, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
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
          body: GestureDetector(
            child: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                Text(
                  'إضافة وصفة جديدة',
                  style: TextStyle(
                      color: black, fontSize: 36, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                Row(children: <Widget>[
                  Text(
                    'المطبخ:',
                    style: TextStyle(
                        color: blue, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  RaisedButton(
                    color: blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: black)),
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          iconEnabledColor: pink,
                          iconSize: 30,
                          style: TextStyle(
                              color: black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900),
                          value: selectedKitchen,
                          onChanged: (value) {
                            setState(() {
                              selectedKitchen = value;
                            });
                          },
                          items: kitchens
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ]),
                DividerV2(),
                Row(
                  children: <Widget>[
                    Text(
                      'التصنيف:',
                      style: TextStyle(
                          color: blue,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.06,
                    ),
                    RaisedButton(
                      color: blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: black)),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            iconEnabledColor: pink,
                            iconSize: 30,
                            style: TextStyle(
                                color: black,
                                fontSize: 12,
                                fontWeight: FontWeight.w900),
                            value: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                DividerV2(),
                InputField(
                  hint: 'أسم الوصفة',
                  isPassword: false,
                  controller: titleController,
                  focusNode: titleFocusNode,
                  validator: (value) {},
                ),
                DividerV2(),
                foodImage == null
                    ? Container()
                    : Image.file(
                        foodImage,
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2),
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
                          'إضافة صورة',
                          style: TextStyle(
                              color: black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Icon(
                          Icons.add_a_photo,
                          color: pink,
                          size: 30,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    onPressed: () {
                      _openImagePicker(context);
                    },
                  ),
                ),
                DividerV2(),
                // FlatButton(child: Text('test'),onPressed: ()async{
                //  String imageLink =  await uploadImage(foodImage);
                //  print(imageLink);
                // },),
                // المقادير
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'المقادير:',
                    style: TextStyle(
                        color: blue,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: black,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ColumnBuilder(
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Transform.rotate(
                                  angle: 29.8,
                                  child: Icon(
                                    Icons.navigation,
                                    color: black,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 6.0),
                                  // height: 40,
                                  child: Text(
                                    ingredients[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  margin: EdgeInsets.only(right: 3.0),
                                  child: RoundedButton(
                                    icon: Icons.remove,
                                    color: blue,
                                    onPressed: () {
                                      setState(() {
                                        ingredients.removeAt(index);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Transform.rotate(
                              angle: 29.8,
                              child: Icon(
                                Icons.navigation,
                                color: black,
                              ),
                            ),
                            input(
                              hint: 'أضف مقدار',
                              controller: ingredientsController,
                              focusNode: ingredientsFocusNode,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 3.0),
                              child: RoundedButton(
                                icon: Icons.add,
                                color: blue,
                                onPressed: () {
                                  if (ingredientsController.text.isNotEmpty) {
                                    setState(() {
                                      ingredients
                                          .add(ingredientsController.text);
                                      ingredientsController.text = '';
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DividerV2(),
                // الخطوات
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    'الخطوات:',
                    style: TextStyle(
                        color: blue,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    border: Border.all(
                      color: black,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ColumnBuilder(
                        itemCount: preparation.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Transform.rotate(
                                  angle: 29.8,
                                  child: Icon(
                                    Icons.navigation,
                                    color: black,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 6.0),
                                  // height: 40,
                                  child: Text(
                                    preparation[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  margin: EdgeInsets.only(right: 3.0),
                                  child: RoundedButton(
                                    icon: Icons.remove,
                                    color: blue,
                                    onPressed: () {
                                      setState(() {
                                        preparation.removeAt(index);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Transform.rotate(
                              angle: 29.8,
                              child: Icon(
                                Icons.navigation,
                                color: black,
                              ),
                            ),
                            input(
                              hint: 'أضف خطوة',
                              controller: preparationController,
                              focusNode: preparationFocusNode,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 3.0),
                              child: RoundedButton(
                                icon: Icons.add,
                                color: blue,
                                onPressed: () {
                                  if (preparationController.text.isNotEmpty) {
                                    setState(() {
                                      preparation
                                          .add(preparationController.text);
                                      preparationController.text = '';
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),

                RaisedButton(
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
                        'إضافة الوصفة',
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
                  onPressed: () async {
                    loading(
                      context,
                      'جاري مراجعة البيانات',
                    );

                    if (selectedKitchen == 'المطبخ') {
                      Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإختيار المطبخ');
                    } else if (selectedCategory == 'التصنيف') {
                                              Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإختيار التصنيف');
                    } else if (titleController.text.isEmpty) {
                                              Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإدخال أسم الوصفة');
                    } else if (foodImage == null) {
                                              Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإدخال صورة');
                    } else if (ingredients.length == 0) {
                                              Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإدخال المقادير');
                    } else if (preparation.length == 0) {
                                              Navigator.pop(context);

                      showAlertMessage(
                          context: context,
                          title: " بيانات ناقصة!!",
                          message: 'قم بإدخال الخطوات');
                    } else {
                      if (await checkInternet()) {
                        String imageURL = await uploadImage(foodImage);
                        Map<String, dynamic> newItem = {
                          'title': titleController.text,
                          'userUID': model.currentUser.userUID,
                          'userName': model.currentUser.userName,
                          'kitchen': selectedKitchen,
                          'category': selectedCategory,
                          'imageURL': imageURL,
                          'ingredients': ingredients,
                          'preparation': preparation,
                          'likedList': []
                        };
                        FirebaseDatabase database = FirebaseDatabase.instance;

                        Navigator.pop(context);
                        loading(
                          context,
                          'جاري رفع وصفتك',
                        );
                        await database
                            .reference()
                            .child('users_posts')
                            .push()
                            .set(newItem)
                            .then((value) {
                          Navigator.pop(context);
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
                                    'تم إضافة وصفتك بنجاح',
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
                        });
                      } else {
                        showAlertMessage(
                            context: context,
                            title: 'حدث خطًأ ما',
                            message: 'تحقق من اتصالك بالأنترنت وحاول مرة أخرى');
                      }
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        );
      },
    );
  }
}
