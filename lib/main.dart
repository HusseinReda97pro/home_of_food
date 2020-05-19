import 'package:flutter/material.dart';
import 'package:home_of_food/data/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_of_food/pages/SplashScreen.dart';
import 'package:home_of_food/pages/add_item/add_item.dart';
import 'package:home_of_food/pages/favorites/favorites_page.dart';
import 'package:home_of_food/pages/home.dart';
import 'package:home_of_food/pages/info/about.dart';
import 'package:home_of_food/pages/unlogedin_user.dart';
import 'package:home_of_food/pages/posts/posts_page.dart';
import 'package:home_of_food/pages/auth/login.dart';
import 'package:home_of_food/pages/auth/signup.dart';
import 'package:provider/provider.dart';
import 'models/shared/main_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final MainModel mainModel = MainModel();


  @override
  Widget build(BuildContext context) {
    mainModel.autoLogin();
    mainModel.getPaths();

    return ChangeNotifierProvider(
      create: (context) => mainModel,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // for RTL dirctions
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            Locale("ar"),
          ],
          locale: Locale("ar"),
          //
          title: 'Flutter Demo',
          theme: appTheme,
          // ThemeData(
          //   primarySwatch: Colors.blue,
          //   visualDensity: VisualDensity.adaptivePlatformDensity,
          // ),
          home: SplashScreen(),
          routes: {
            '/home': (BuildContext context) => HomePage(),
            '/login': (BuildContext context) => Login(),
            '/signup': (BuildContext context) => SignUp(),
            // '/profile': (BuildContext context) => ProfilePage(ModalRoute.of(context).settings.arguments),
            '/unlogedin': (BuildContext context) => UnLogedinUser(),
            '/add_item': (BuildContext context) => AddItem(),
            '/users_posts': (BuildContext context) => PostsPage(),
            '/favorits': (BuildContext context) => FavoritesPage(),
            '/about': (BuildContext context) => About()
          }),
    );
  }
}
