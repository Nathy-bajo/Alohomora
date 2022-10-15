import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/finalpassword.dart';
import 'package:login_form/loginpage.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

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

  TextEditingController _email = TextEditingController();

  Future postData() async {
    const String pathUrl = 'http://192.168.100.50:8080/forgot';

    try {
      Response response = await dio.post(pathUrl, data: {"email": _email.text});
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
          title: const Text("Change password here"),
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_sharp,
              ),
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()))
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
                child: Image.asset('images/mail.png'),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _email,
                onChanged: (_email) {
                  print('email: $_email');
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as example@gmail.com'),
              )),
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
                          builder: (context) => const FinalPassword()));
                },
                child: const Text(
                  'Click to reset password',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
        ])));
  }
}
