 import 'package:connectivity/connectivity.dart';

Future<bool> checkInternet() async {
    bool isOnline;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isOnline = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isOnline = true;
    } else if (connectivityResult == ConnectivityResult.none) {
      isOnline = false;
    }
    return isOnline;
  }