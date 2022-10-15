import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/actionpage.dart';
import 'package:login_form/loginpage.dart';
import 'package:login_form/token.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

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
  TextEditingController _password = TextEditingController();
  TextEditingController _new_password = TextEditingController();
  TextEditingController _confirm_password = TextEditingController();
  TextEditingController _email = TextEditingController();

  Future postData() async {
    const String pathUrl = 'http://192.168.100.50:8080/reset';
    try {
      dio.options.headers['content-Type'] = 'application/json';

      Response response = await dio.post(pathUrl, data: {
        "email": _email.text,
        "current_password": _password.text,
        "new_password": _new_password.text,
        "new_password_check": _confirm_password.text
      });
      // (response.data["token"]);
      storage.read(
        key: 'token',
      );
      print('Successfully updated: ${response.data["token"]}');
      return response.data["token"];
    } on DioError catch (e) {
      print('unknown error ma gee: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Password"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_sharp,
              ),
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ActionPage()))
                  }),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('images/password.png'),
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
                controller: _password,
                onChanged: (password) {
                  print('current password: $password');
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Current Password',
                    hintText: 'Enter current password')),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 0),
            child: TextField(
                controller: _new_password,
                onChanged: (new_password) {
                  print('new password: $new_password');
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                    hintText: 'Enter new password')),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 0),
            child: TextField(
                controller: _confirm_password,
                onChanged: (confirm_password) {
                  print('confirm password: $confirm_password');
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
