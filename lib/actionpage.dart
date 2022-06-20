// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/changepassword.dart';
import 'package:login_form/loginpage.dart';
import 'token.dart';


class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<ActionPage> {
  Dio dio = Dio();

  Future postData({action = String}) async {
    const String pathUrl = 'http://192.168.100.6:8080/door';
    print(action);
    var token = await storage.read(
      key: "token",
    );

    setAuthToken(token);

    print("$token allah");
    try {
      Response response = await dio.post(pathUrl,
          data: {"action": action},
          options: Options(headers: {
            "Authorization": "Bearer: $token"
          }));

      print('$token');

      print('Action successful: ${response.data["token"]}');
      return response.data["token"];
    } on DioError catch (e) {
      print('something happened sha: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Action"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
          ),
          onPressed: () =>  {
             Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()))
          }
      ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Open/Close the door on your phone :D",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () {
                setState(() async {
                  await postData(action: "open");
                });
              },
              child: const Text(
                "Open",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () {
                setState(() async {
                  await postData(action: "close");
                });
              },
              child: const Text(
                "close",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePassword()));
            },
            child: const Text(
              'Click To Change Password',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
