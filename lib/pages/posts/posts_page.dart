import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:home_of_food/pages/posts/posts_list/posts_list.dart';
import 'package:home_of_food/widgets/app_drawer/app_drawer.dart';
import 'package:home_of_food/widgets/appbar.dart';
import 'package:home_of_food/data/Palette.dart';
import 'package:provider/provider.dart';
import 'package:home_of_food/models/shared/main_model.dart';

class PostsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostsPageState();
  }
}

class PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainModel>(builder: (context, model, chlild) {
      return Scaffold(
        drawer: AppDrawer(),
        appBar: MainAppBar(
          context: context,
        ),
        body: model.loadingPosts ?
        Transform.rotate(
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
        ):PostList(posts: model.posts,),
      );
    });
  }
}
