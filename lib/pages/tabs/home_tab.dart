// import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:home_of_food/pages/tabs/widgets/kitchen_card.dart';

class HomePageTab extends StatefulWidget {
  @override
  _HomePageTabState createState() => _HomePageTabState();
}

class _HomePageTabState extends State<HomePageTab> {
  // bool isOnline = true;

  // Future<bool> cheecknet() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     isOnline = true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     isOnline = true;
  //   } else if (connectivityResult == ConnectivityResult.none) {
  //     isOnline = false;
  //   }
  //   return isOnline;
  // }
  List<String> kitchens = [
    'عالمي',
    'مطابخ آخرى',
    'سعودي',
    'هندي',
    'مكسيكي',
    'عربي',
    'تركي',
    'مغربي',
    'إيطالي',
    'أوروبي',
    'شامي',
    'آسيوي',
    'خليجي',
    'مصري',
    'أمريكي',
    'غربي'
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: kitchens.length,
        itemBuilder: (context, index) {
          return KitchenCard(title: kitchens[index]);
        },
      ),
    );
  }
}
