import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../post.dart';

mixin PostsModel on ChangeNotifier {
  bool loadingPosts = false;
  List<Post> posts = [];
  List<Post> profilePosts = [];
  bool loadingProfile;
  int totalLieks = 0;

  Future<void> getPosts() async {
    loadingPosts = true;
    notifyListeners();
    var data = FirebaseDatabase.instance.reference().child("users_posts");
    posts.clear();
    try {
      await data.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, value) {
          List<String> likedLIst = [];
          if (value['likedList'] != null) {
            value['likedList'].forEach((key, value) {
              likedLIst.add(key);
            });
          } else {
            likedLIst = [];
          }
          Post post = Post(
              postID: key,
              title: value['title'],
              category: value['category'],
              imageURL: value['imageURL'],
              ingredients: value['ingredients'],
              kitchen: value['kitchen'],
              preparation: value['preparation'],
              userName: value['userName'],
              userUID: value['userUID'],
              likedList: likedLIst);
          posts.add(post);
        });
      });
    } catch (_) {}
    loadingPosts = false;
    notifyListeners();
  }

  void getProfilePosts({@required userUID}) async {
    loadingProfile = true;
    notifyListeners();
    totalLieks = 0;
    profilePosts.clear();
    await getPosts();
    for (Post post in posts) {
      if (post.userUID == userUID) {
        totalLieks += post.likedList.length;
        profilePosts.add(post);
      }
    }

    loadingProfile = false;
    notifyListeners();
  }

  void addFavorite({postID, userUID}) async {
    Post post = posts.firstWhere((element) => element.postID == postID);
    post.likedList.add(userUID);
    Map<String, String> like = {'date': DateTime.now().toString()};

    FirebaseDatabase.instance
        .reference()
        .child("users_posts")
        .child(postID)
        .child('likedList')
        .child(userUID)
        .set(like);

    notifyListeners();
  }

  void removeFavorite({postID, userUID}) async {
    Post post = posts.firstWhere((element) => element.postID == postID);
    post.likedList.remove(userUID);

    FirebaseDatabase.instance
        .reference()
        .child("users_posts")
        .child(postID)
        .child('likedList')
        .child(userUID)
        .remove();

    // FirebaseDatabase.instance
    //     .reference()
    //     .child("users_posts")
    //     .child(postID)
    //     .child('likedList')
    //     .child(userUID)
    //     .once()
    //     .then((snapshot) {
    //   snapshot.value.ref.reomve();
    // });

    // FirebaseDatabase.instance
    //     .reference()
    //     .child("users_posts/$postID/ikedList/$userUID")
    //     .remove();
    notifyListeners();
  }
}
