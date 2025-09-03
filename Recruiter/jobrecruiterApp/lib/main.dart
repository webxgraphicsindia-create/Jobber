import 'package:flutter/material.dart';

import 'Screens/Auth/SplashScreen.dart';

void main() {
  // runApp(MyApp());
  runApp(
    MyApp(),
    );
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MySplashscreen(),
      //home: MyMainScren(),
    );
  }

}



