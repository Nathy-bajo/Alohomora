// ignore: file_names
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/changepassword.dart';
import 'package:login_form/loginpage.dart';
import 'package:login_form/video.dart';
import 'token.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<ActionPage> {
  bool isSwitched = bool as bool;
  var textValue;
  var timer;

  Future getDoorState({action = String}) async {
    var data;
    const String pathUrl = 'http://192.168.100.6:8080/polling';
    print(action);
    var token = await storage.read(
      key: "token",
    );

    setAuthToken(token);

    try {
      Response response = await dio.get(pathUrl,
          options: Options(headers: {"Authorization": "Bearer: $token"}));

      print('Action successful: ${response.data["door"]}');
      data = response.data["door"];
      return data;
    } on DioError catch (e) {
      print('Oppsss: $e');
      data = "oops someting went wrong";
    }
  }

  loadDoor() async {
    getDoorState().then((value) async {
      if (value == "open") {
        setState(() {
          isSwitched = true;
          textValue = 'Door has been unlocked';
        });
      } else {
        setState(() {
          isSwitched = false;
          textValue = 'Door has been locked';
        });
      }
      print('value: $value');
      return value;
    });
  }

  void toggleSwitch(bool value) {
    if (isSwitched == bool) {
      setState(() {
        postData(action: "close");
        isSwitched = true;
        textValue = 'Door has been locked';
      });
      print('Door has been locked');
    } else {
      setState(() {
        postData(action: "open");
        isSwitched = false;
        textValue = 'Door has been unlocked';
      });
      print('Door has been unlocked');
    }
  }

  Dio dio = Dio();

  Future postData({action = String}) async {
    const String pathUrl = 'http://192.168.100.6:8080/door';
    print(action);
    var token = await storage.read(
      key: "token",
    );

    setAuthToken(token);

    // print("$token allah");
    try {
      Response response = await dio.post(pathUrl,
          data: {"action": action},
          options: Options(headers: {"Authorization": "Bearer: $token"}));

      // print('$token');

      print('Action successful: ${response.data["token"]}');
      return response.data["token"];
    } on DioError catch (e) {
      print('something happened sha: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) => loadDoor());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Action Page"),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15),
            //   child: ElevatedButton(
            //       onPressed: toggleSwitch(),
            //       child: Text('data')),
            // ),
            Transform.scale(
              scale: 2,
              child: Switch(
                onChanged: toggleSwitch,
                value: isSwitched,
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.redAccent,
                inactiveTrackColor: Colors.red,
              ),
            ),
            Text(
              textValue,
              style: const TextStyle(fontSize: 20),
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
                TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VideoPage()));
            },
            child: const Text(
              'video route?',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
