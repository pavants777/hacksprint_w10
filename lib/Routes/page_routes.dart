import 'package:cmc/Screens/SplashScreens/HomePage.dart';
import 'package:cmc/Screens/SplashScreens/LoginPage.dart';
import 'package:cmc/Screens/SplashScreens/SignIn.dart';
import 'package:cmc/main.dart';
import 'package:flutter/material.dart';

class Routes {
  static final String startPage = '/';
  static final String homePage = '/home';
  static final String loginPage = '/login';
  static final String signIn = '/signin';

  static Map<String, WidgetBuilder> route = {
    startPage: (context) => StartPage(),
    homePage: (context) => HomePage(),
    loginPage: (context) => LoginPage(),
    signIn: (context) => SignIn(),
  };
}
