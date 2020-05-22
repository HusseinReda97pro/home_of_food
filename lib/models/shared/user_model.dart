import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_of_food/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin UserModel on ChangeNotifier {
  User currentUser;
  bool signingup = false;
  bool logingin = false;
  final _auth = FirebaseAuth.instance;
  String anotherUserfbLink;

  Future<String> signUp(email, password, userName, fbLink) async {
    signingup = true;
    notifyListeners();
    try {
      var userUID;
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
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

  // Facebook signup
  Future<String> signupWithFB() async {
    String message;
    signingup = true;
    notifyListeners();
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final token = result.accessToken.token;
          final graphResponse = await http.get(
              'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
          final profile = json.decode(graphResponse.body);
          final facebookAuthCred =
              FacebookAuthProvider.getCredential(accessToken: token);
          var user = (await _auth.signInWithCredential(facebookAuthCred)).user;
          FirebaseDatabase database = FirebaseDatabase.instance;
          Map<String, String> userData = {
            'userName': profile['name'],
            'fbLink': null
          };
          database.reference().child('users').child(user.uid).set(userData);
          socialLogin(
              userUID: user.uid,
              email: user.email,
              displayuserName: user.displayName);
          message = 'successfully';
        } catch (error) {
          switch (error.code) {
            case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
              message = 'الأيميل المستخدم لحساب الفيس بوك مسجل بالفعل!';
              break;
          }
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        message = 'لقد قمت برفض الدخول عن طريق الفيس بوك';
        break;
      case FacebookLoginStatus.error:
        message = 'حدث خطأ غير معروف';
        break;
    }
    signingup = false;
    notifyListeners();
    return message;
  }

  // Facebook login
  Future<String> loginWithFB() async {
    String message;
    logingin = true;
    notifyListeners();
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final token = result.accessToken.token;
          final facebookAuthCred =
              FacebookAuthProvider.getCredential(accessToken: token);
          // final graphResponse = await http.get(
          //     'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
          // final profile = json.decode(graphResponse.body);

          var user = (await _auth.signInWithCredential(facebookAuthCred)).user;
          socialLogin(
              userUID: user.uid,
              email: user.email,
              displayuserName: user.displayName);
          message = 'successfully';
        } catch (error) {
          switch (error.code) {
            case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
              message = 'الأيميل المستخدم لحساب الفيس بوك مسجل بالفعل!';
              break;
          }
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        message = 'لقد قمت برفض الدخول عن طريق الفيس بوك';
        break;
      case FacebookLoginStatus.error:
        message = 'حدث خطأ غير معروف';
        break;
    }
    logingin = false;
    notifyListeners();
    return message;
  }

// google signup
  Future<String> googleSignup() async {
    signingup = true;
    notifyListeners();
    String message;
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential googleAuthCred = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user = (await _auth.signInWithCredential(googleAuthCred)).user;
      FirebaseDatabase database = FirebaseDatabase.instance;
      Map<String, String> userData = {
        'userName': user.displayName,
        'fbLink': null
      };
      database.reference().child('users').child(user.uid).set(userData);
      socialLogin(
          userUID: user.uid,
          email: user.email,
          displayuserName: user.displayName);
      message = 'successfully';
    } catch (error) {
      message = 'حدث خطأ غير معروف';
    }
    signingup = false;
    notifyListeners();
    return message;
  }

  // google login
  Future<String> googleLogin() async {
    logingin = true;
    notifyListeners();
    String message;
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential googleAuthCred = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var user = (await _auth.signInWithCredential(googleAuthCred)).user;
      socialLogin(
          userUID: user.uid,
          email: user.email,
          displayuserName: user.displayName);
      message = 'successfully';
    } catch (error) {
      message = 'حدث خطأ غير معروف';
      // message = error.toString();
    }
    logingin = false;
    notifyListeners();
    return message;
  }

// login for google and facebook to save user data in shared prefrances and modle
  socialLogin(
      {@required userUID, @required email, @required displayuserName}) async {
    String userName, fbLink;

    bool exist;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userUID)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        exist = false;
      } else {
        exist = true;
      }
    });
    if (exist) {
      var db =
          FirebaseDatabase.instance.reference().child("users").child(userUID);
      await db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        userName = values['userName'];
        fbLink = values['fbLink'];
      });
    } else {
      userName = displayuserName;
      FirebaseDatabase database = FirebaseDatabase.instance;
      Map<String, String> userData = {'userName': userName, 'fbLink': null};
      database.reference().child('users').child(userUID).set(userData);
    }
    // print('display : '+ displayuserName);
    // print('userName : '+ userName);

    currentUser = User(
        userUID: userUID, email: email, userName: userName, fbLink: fbLink);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userEmail", email);
    prefs.setString("userUID", userUID);
    prefs.setString("userName", userName);
    prefs.setString("fbLink", fbLink);
  }

  Future<bool> addFBLink(link) async {
    try {
      FirebaseDatabase database = FirebaseDatabase.instance;
      await database
          .reference()
          .child('users')
          .child(currentUser.userUID)
          .child('fbLink')
          .set(link);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("fbLink", link);
      currentUser.fbLink = link;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> getFBLink(userUID) async {
    String fbLink;
    try {
      var db =
          FirebaseDatabase.instance.reference().child('users').child(userUID);
      await db.once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        fbLink = values['fbLink'];
      });
      anotherUserfbLink = fbLink;
      notifyListeners();
    } catch (_) {
      return null;
    }
  }
}
