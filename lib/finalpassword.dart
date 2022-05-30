// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/loginpage.dart';

class FinalPassword extends StatelessWidget {
  const FinalPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  const LoginDemo({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  Dio dio = Dio();
  final TextEditingController _reset_password = TextEditingController();
  final TextEditingController _confirm_password = TextEditingController();
  final TextEditingController _token = TextEditingController();
  final TextEditingController _email = TextEditingController();


  Future postData() async {
    const String pathUrl = 'http://192.168.100.204:8080/email';

    try {

      Response response = await dio.post(pathUrl, data: {
        "email": _email.text,
        "reset_password": _reset_password.text,
        "confirm_password": _confirm_password.text,
        "token": _token.text
      });
      print('Response body: ${response.data.toString()}');
      return response.data;
    } on DioError catch (e) {
      print('unknown error ma gee: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
             title: const Text("Email Page"),
            ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('images/final.png'),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _email,
                onChanged: (email) {
                  print('email: $email');
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as example@gmail.com'),
              )),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 0),
            child: TextField(
                controller: _reset_password,
                onChanged: (_password) {
                  print('New password: $_password');
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter New Password',
                    hintText: 'Enter new password')),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 0),
            child: TextField(
                controller: _confirm_password,
                onChanged: (_confirm_password) {
                  print('confirm password: $_confirm_password');
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Confirm new password')),
          ),
          Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  postData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
                child: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
        ])));
  }
}
