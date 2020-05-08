import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_of_food/models/user.dart';

mixin UserModel on ChangeNotifier {
  User currentUser;
  bool signingup = false;
  bool logingin = false;
  final _auth = FirebaseAuth.instance;

  Future<String> signUp(email, password, userName, fbLink) async {
    signingup = true;
    notifyListeners();
    try {
      var userUID;
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      // if(newUser == 'ERROR_WEAK_PASSWORD'){

      // }
      print(newUser);
      if (newUser != null) {
        userUID = newUser.user.uid;
        FirebaseDatabase database = FirebaseDatabase.instance;
        Map<String, String> user = {'userName': userName, 'fbLink': fbLink};
        database.reference().child('users').child(userUID).set(user);
      }
      signingup = false;
      notifyListeners();
      return 'successfully';
    } catch (error) {
      String errorMessage;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "البريد الألكتروني غير صالح";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "الرقم السري غير صحيح";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "المستخدم غير موجود";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "المستخدم موقوف";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "هناك خطأ ما, حاول لاحقا";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "غير مسموج!!";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "هذا البريد الألكتروني موجود بالفعل";
          break;
        default:
          errorMessage = "مشكلة غير معروفة!";
      }
      signingup = false;
      notifyListeners();
      return errorMessage;
    }
  }

  Future<String> login(email, password) async {
    logingin = true;
    notifyListeners();
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      if (user != null) {
        var userUID = user.user.uid;
        var userName;
        var fbLink;
        var db =
            FirebaseDatabase.instance.reference().child("users").child(userUID);
        await db.once().then((DataSnapshot snapshot) {
          Map<dynamic, dynamic> values = snapshot.value;
          userName = values['userName'];
          fbLink = values['fbLink'];
        });

        currentUser = User(
            userUID: userUID, email: email, userName: userName, fbLink: fbLink);

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userEmail", email);
        prefs.setString("userUID", userUID);
        prefs.setString("userName", userName);
        prefs.setString("fbLink", fbLink);
        logingin = false;
        notifyListeners();
        return 'successfully';
      } else {
        return "مشكلة غير معروفة!";
      }
    } catch (error) {
      String errorMessage;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "البريد الألكتروني غير صالح";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "الرقم السري غير صحيح";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "المستخدم غير موجود";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "المستخدم موقوف";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "هناك خطأ ما, حاول لاحقا";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "غير مسموج!!";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "هذا البريد الألكتروني موجود بالفعل";
          break;
        default:
          errorMessage = "مشكلة غير معروفة!";
      }
      logingin = false;
      notifyListeners();
      return errorMessage;
    }
  }

  void autoLogin() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userEmail = prefs.getString("userEmail");
      final String userUID = prefs.getString("userUID");
      final String userName = prefs.getString("userName");
      final String fbLink = prefs.getString("fbLink");

      currentUser = User(
          userUID: userUID,
          email: userEmail,
          userName: userName,
          fbLink: fbLink);
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUser = null;
    prefs.remove('userEmail');
    prefs.remove('userUID');
    prefs.remove('userName');
    prefs.remove('fbLink');
  }
}
