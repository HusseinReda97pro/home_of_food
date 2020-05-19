// for ads
import 'package:firebase_admob/firebase_admob.dart';

const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  // keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

String appID = 'ca-app-pub-9506840191616541~1954603249';