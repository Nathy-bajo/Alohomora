import 'package:flutter/material.dart';
import 'package:login_form/loginpage.dart';
import 'package:login_form/actionpage.dart';
import 'package:login_form/changepassword.dart';
import 'package:login_form/forgotpassword.dart';
import 'package:login_form/finalpassword.dart';
import 'package:login_form/splash.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/login': (context) => const LoginPage(), 
      '/door': (context) =>  const ActionPage(),
      '/reset': (context) => const ChangePassword(),
      '/forgot': (context) => const ForgotPassword(),
      '/email': (context) => const FinalPassword(),
      '/splash': (context) => const HomePage(),
      // '/video': (context) => const VideoPage()
    },
  ));
}

