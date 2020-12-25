import 'package:flutter/material.dart';

// ----- bloc
import 'BLoC/device_bloc.dart';
// ----- screen
import 'Screens/Login/login_screen.dart';
import 'Screens/Home/home_screen.dart';
import 'Screens/GenerateQR/generate_qr_screen.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DeviceBloc _deviceBloc;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    //
    _deviceBloc = DeviceBloc();

    // firebase
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      // init
      _deviceBloc.init(token: token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.route:
            return MaterialPageRoute(builder: (_) => LoginScreen());
            break;
          case HomeScreen.route:
            return MaterialPageRoute(builder: (_) => HomeScreen());
            break;
          case GenerateQRScreen.route:
            String accountNumber = settings.arguments;
            return MaterialPageRoute(
                builder: (_) => GenerateQRScreen(accountNumber: accountNumber));
            break;
          default:
            return MaterialPageRoute(builder: (_) => LoginScreen());
        }
      },
    );
  }
}
