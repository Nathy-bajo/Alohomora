import 'package:flutter/services.dart';
import 'package:login_form/token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/actionpage.dart';
import 'package:login_form/forgotpassword.dart';
import 'package:login_form/store.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<Login> {
  Dio dio = Dio();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  static const platform = MethodChannel('samples.flutter.dev/device_token');

  Future<void> getDeviceToken() async {
    const String pathUrl = 'http://192.168.100.6:8080/notification';
    print('Testing');
    var token = await storage.read(
      key: "token",
    );

    setAuthToken(token);

    try {
      final String result = await platform.invokeMethod('getDeviceToken');
      print('Access token? $result');
      Response response = await dio.post(pathUrl,
          data: {"device_token": result},
          options: Options(headers: {"Authorization": "Bearer: $token"}));
      return response.data["getDeviceToken"];
    } on PlatformException catch (_) {}
  }

  Future postData() async {
    const String pathUrl = 'http://192.168.100.6:8080/login';

    try {
      Response response = await dio
          .post(pathUrl, data: {"email": email.text, "pw": password.text});

      await storage.write(key: "token", value: response.data["token"]);
      print('Login successful: ${response.data["token"]}');
      return response.data["token"];
    } on DioError catch (e) {
      print('unknown error ma gee: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getDeviceToken();

    init();
  }

  Future init() async {
    final email = await UserSecureStorage.getEmail() ?? '';
    final password = await UserSecureStorage.getPassword() ?? '';
    setState(() {
      this.email.text = email;
      this.password.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('images/imager.png'),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: email,
                onChanged: (email) {
                  print('email: $email');
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    // value: 'email',
                    hintText: 'Enter valid email id as example@gmail.com'),
              )),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15.0, bottom: 0),
            child: TextField(
              controller: password,
              onChanged: (pw) {
                print('password: $pw');
              },
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password'),
            ),
          ),
          TextButton(
            onPressed: () {
              // registerForRemoteNotifications();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()));
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
          Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  await UserSecureStorage.setEmail(email.text);
                  await UserSecureStorage.setPassword(password.text);
                  await postData();

                  print({email.text, password.text});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ActionPage()));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              )),
        ])));
  }
}

// void registerForRemoteNotifications() {}
