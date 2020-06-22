import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/login.dart';
import 'package:todo_app/screens/signup.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: colors.mainColor,
          accentColor: colors.mainColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows : CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS : CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux : CupertinoPageTransitionsBuilder(),
            TargetPlatform.fuchsia : CupertinoPageTransitionsBuilder(),

          })),
        initialRoute: "/",
        routes: {
          '/': (context) => HomeScreen(from: false,),
    '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
  },  
    );
  }

}


