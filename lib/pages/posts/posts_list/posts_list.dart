import 'package:flutter/material.dart';
import 'package:home_of_food/models/post.dart';
import 'package:home_of_food/pages/posts/posts_list/widgets/post_list_card.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  PostList({this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostListCard(
            post: posts[index],
          );
        });
  }
}
