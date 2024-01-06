import 'package:cmc/Screens/Meeting/meetingHome.dart';
import 'package:cmc/Screens/SplashScreens/HomePage.dart';
import 'package:cmc/Screens/SplashScreens/LoginPage.dart';
import 'package:cmc/Screens/SplashScreens/SignIn.dart';
import 'package:cmc/Screens/ToDo/Todo_home.dart';
import 'package:cmc/main.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String startPage = '/';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String signIn = '/signin';
  static const String meeting = '/meeting';
  static const String todo = '/todo';

  static Map<String, WidgetBuilder> route = {
    startPage: (context) => const StartPage(),
    homePage: (context) => const HomePage(),
    loginPage: (context) => const LoginPage(),
    signIn: (context) => const SignIn(),
    meeting: (context) => const MeetingHome(),
    todo: (context) => ToDoHome(),
  };
}
