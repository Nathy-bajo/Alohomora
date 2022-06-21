// ignore: file_names
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_form/changepassword.dart';
import 'package:login_form/loginpage.dart';
import 'token.dart';
import 'notifactions.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<ActionPage> {
  bool isSwitched = false;
  var textValue = 'Door has been unlocked';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        postData(action: "open");
        NotificationApi.showNotification(
            title: 'Test door',
            body: 'Door has been opened.',
            payload: 'test.door');

        isSwitched = true;
        textValue = 'Door has been unlocked';
      });
      print('Door has been locked');
    } else {
      setState(() {
        postData(action: "close");
        NotificationApi.showNotification(
            title: 'Test door',
            body: 'Door has been closed.',
            payload: 'test.door');

        isSwitched = false;
        textValue = 'Door has been locked';
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

    print("$token allah");
    try {
      Response response = await dio.post(pathUrl,
          data: {"action": action},
          options: Options(headers: {"Authorization": "Bearer: $token"}));

      print('$token');

      print('Action successful: ${response.data["token"]}');
      return response.data["token"];
    } on DioError catch (e) {
      print('something happened sha: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const ActionPage(),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Action"),
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
            children:<Widget> [
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
            ],
           ),
        ),
        );
  }
}
