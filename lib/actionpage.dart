// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/changepassword.dart';
import 'token.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<ActionPage> {
  Dio dio = Dio();

  Future postData({action = String}) async {
    const String pathUrl = 'http://192.168.100.204:8080/door';
    print(action);
    var token = await storage.read(
      key: 'token',
    );
    try {
      Response response = await dio.post(pathUrl,
          data: {"action": action},
          options: Options(headers: {"Authorization": "Bearer ${checkTokenValidity(token)}"}));

      print('$token');
      (response.data["token"]);

      // ignore: avoid_print
      print(response.statusCode);
      // ignore: avoid_print
      print(response.data);
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
              onPressed: () async {
                await postData(action: "open");
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
              onPressed: () async {
                await postData(action: "close");
              },
              child: const Text(
                "Close",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              // await postData();
              Navigator.push(
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
