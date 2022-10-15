import 'package:flutter/material.dart';
import 'package:socket_io/socket_io.dart';

class SocketPage extends StatefulWidget {
  const SocketPage({Key? key}) : super(key: key);

  @override
  NotificationPage createState() => NotificationPage();
}

class NotificationPage extends State<SocketPage> {
  var io = new Server();
  

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
