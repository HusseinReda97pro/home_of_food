import 'package:flutter/material.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:home_of_food/models/post.dart';
import 'package:home_of_food/models/shared/main_model.dart';
import 'package:home_of_food/pages/food_item/food_item.dart';
import 'package:home_of_food/pages/profile/profile.dart';
import 'package:home_of_food/widgets/divider.dart';
import 'package:provider/provider.dart';

class PostListCard extends StatelessWidget {
  final Post post;
  PostListCard({this.post});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, chlild) {
      return GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: black,
                ),
              ),
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(1.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.03),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          border: Border.all(color: Color(0XFF707070)),
                          borderRadius: BorderRadius.all(
                            Radius.circular(40.0),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: Text(
                            post.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              color: pink,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.03,
                        right: MediaQuery.of(context).size.width * 0.05,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF707070)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/kitchens/' +
                                  post.kitchen.split(' ')[0] +
                                  '.jpg',
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.025,
                        left: MediaQuery.of(context).size.width * 0.05,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0XFF707070)),
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                          child: ClipOval(
                            child: FadeInImage(
                              image: NetworkImage(post.imageURL),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder:
                                  AssetImage('assets/placeholder_image.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DividerV2(),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child:
                              post.likedList.contains(model.currentUser.userUID)
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
                            post.likedList.contains(model.currentUser.userUID)
                                ? model.removeFavorite(
                                    postID: post.postID,
                                    userUID: model.currentUser.userUID)
                                : model.addFavorite(
                                    postID: post.postID,
                                    userUID: model.currentUser.userUID);
                          },
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: Text(
                          post.likedList.length.toString() + ' إعجاب',
                          style: TextStyle(
                              fontSize: 20,
                              color: black,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 6,
              left: 35,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  color: Colors.white,
                  child: Text(
                    post.userName,
                    style: TextStyle(
                        color: black,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                onTap: () {
                  model.getProfilePosts(userUID: post.userUID);
                  model.getFBLink(post.userUID);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProfilePage(
                        myProfile: model.currentUser.userUID == post.userUID
                            ? true
                            : false,
                        title: post.userName,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FoodItemPage(post: post)));
        },
      );
    });
  }
}
