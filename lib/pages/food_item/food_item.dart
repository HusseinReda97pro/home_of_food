import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/food_item.dart';
import 'package:home_of_food/models/post.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/food_item/widgets/image_card.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/widgets/columnbuilder/columnbuilder.dart';
import 'package:home_of_food/widgets/divider.dart';
import 'package:home_of_food/widgets/rowbuilder/rowbuilder.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:home_of_food/data/ads.dart';

class FoodItemPage extends StatefulWidget {
  final FoodItem foodItem;
  final Post post;
  FoodItemPage({this.foodItem, this.post});

  @override
  State<StatefulWidget> createState() {
    return FoodItemPageState();
  }
}

class FoodItemPageState extends State<FoodItemPage> {
  String getFoodText() {
    String message = '';
    if (widget.post != null) {
      message += widget.post.title;
      message += '\n\n';
      message += 'المقادير :';
      message += '\n\n';
      for (var item in widget.post.ingredients) {
        message += item + '\n';
      }
      message += '\n\n';

      message += 'خطوات التحضير :';
      message += '\n\n';
      for (var item in widget.post.preparation) {
        message += item + '\n';
      }
    } else {
      message += widget.foodItem.title;
      message += '\n\n';
      message += 'المقادير :';
      message += '\n\n';
      for (var item in widget.foodItem.ingredients) {
        message += item + '\n';
      }
      message += '\n\n';

      message += 'خطوات التحضير :';
      message += '\n\n';
      for (var item in widget.foodItem.preparation) {
        message += item + '\n';
      }
    }
    message += '\n\n';
    message +=
        'تم مشاركة هذه الوصفة بواسطة تطبيق home of food يمكنك تحميله من الرابط التالي :';
    message += '\n';
    message +=
        'https://play.google.com/store/apps/details?id=com.progx.home_of_food';
    return message;
  }

// ads
  BannerAd _bannerAd;
  bool firstClick = true;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-9506840191616541/3521576602',
      // adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {},
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-9506840191616541/3871810839',
      //  adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: appID);
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
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
          body: ListView(
            children: <Widget>[
              FoodItemImageCard(
                imagePath:
                    widget.post == null ? widget.foodItem.imagePath : null,
                imageURL: widget.post == null ? null : widget.post.imageURL,
                title: widget.post == null
                    ? widget.foodItem.title
                    : widget.post.title,
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'المطبخ:',
                      style: TextStyle(
                          color: blue,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.post == null
                            ? widget.foodItem.kitchen
                            : widget.post.title,
                        style: TextStyle(
                            color: black,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    widget.post == null
                        ? Container(
                            margin: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: model.imagePaths
                                      .contains(widget.foodItem.imagePath)
                                  ? Icon(
                                      Icons.favorite,
                                      color: pink,
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: pink,
                                      size: 35,
                                    ),
                              onTap: () {
                                model.imagePaths
                                        .contains(widget.foodItem.imagePath)
                                    ? model.deleteFromFavorites(
                                        widget.foodItem.imagePath)
                                    : model.addToFavorites(
                                        widget.foodItem.imagePath);
                              },
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              child: widget.post.likedList
                                      .contains(model.currentUser.userUID)
                                  ? Icon(
                                      Icons.favorite,
                                      color: pink,
                                      size: 35,
                                    )
                                  : Icon(
                                      Icons.favorite_border,
                                      color: pink,
                                      size: 35,
                                    ),
                              onTap: () {
                                widget.post.likedList
                                        .contains(model.currentUser.userUID)
                                    ? model.removeFavorite(
                                        postID: widget.post.postID,
                                        userUID: model.currentUser.userUID)
                                    : model.addFavorite(
                                        postID: widget.post.postID,
                                        userUID: model.currentUser.userUID);
                              },
                            ),
                          ),
                  ],
                ),
              ),
              DividerV2(),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'التصنيف:',
                      style: TextStyle(
                          color: blue,
                          fontSize: 24,
                          fontWeight: FontWeight.w900),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: RowBuilder(
                            itemCount: widget.post == null
                                ? widget.foodItem.category.length
                                : [widget.post.category].length,
                            itemBuilder: (context, index) {
                              if (widget.post == null) {
                                if (index <
                                    widget.foodItem.category.length - 1) {
                                  widget.foodItem.category[index] += ", ";
                                }
                              }
                              return Text(
                                widget.post == null
                                    ? widget.foodItem.category[index]
                                    : widget.post.category,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // المقادير
              DividerV2(),
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
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: blue.withOpacity(0.1),
                    blurRadius: 20.0,
                  ),
                ]),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: ColumnBuilder(
                      itemCount: widget.post == null
                          ? widget.foodItem.ingredients.length
                          : widget.post.ingredients.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: Row(children: <Widget>[
                            Transform.rotate(
                              angle: 29.8,
                              child: Icon(
                                Icons.navigation,
                                color: black,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.post == null
                                      ? widget.foodItem.ingredients[index]
                                      : widget.post.ingredients[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // خطوات التحضير
              DividerV2(),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'خطوات التحضير:',
                  style: TextStyle(
                      color: blue,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline),
                ),
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: blue.withOpacity(0.1),
                    blurRadius: 20.0,
                  ),
                ]),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    child: ColumnBuilder(
                      itemCount: widget.post == null
                          ? widget.foodItem.preparation.length
                          : widget.post.preparation.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Transform.rotate(
                                  angle: 29.8,
                                  child: Icon(
                                    Icons.navigation,
                                    color: black,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    widget.post == null
                                        ? widget.foodItem.preparation[index]
                                        : widget.post.preparation[index],
                                    overflow: TextOverflow.clip,
                                    maxLines: 5,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.48,
                    margin: EdgeInsets.all(5.0),
                    child: RaisedButton(
                      color: blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: black)),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'مشاركة الوصفة',
                            style: TextStyle(
                                color: black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            Icons.screen_share,
                            color: pink,
                            size: 30,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (firstClick) {
                          createInterstitialAd()
                            ..load()
                            ..show();
                          firstClick = !firstClick;
                        } else {
                          Share.share(getFoodText(),
                              subject: 'Home of food APP');
                          firstClick = !firstClick;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        );
      },
    );
  }
}
