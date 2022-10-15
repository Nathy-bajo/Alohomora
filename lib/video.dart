import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:login_form/actionpage.dart';
// import 'package:patrolling_robot/src/styles/styles.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _MainPageState();
}

class _MainPageState extends State<VideoPage> {
  static const String url = "ws://192.168.100.50:8080/ws";
  WebSocketChannel? _channel;
  bool _isConnected = false;

  void connect() {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    setState(() {
      _isConnected = true;
    });
  }

  void disconnect() {
    _channel!.sink.close();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Live Video"),
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: connect,
                      style: const ButtonStyle(),
                      child: const Text("Connect"),
                    ),
                    ElevatedButton(
                      onPressed: disconnect,
                      style: const ButtonStyle(),
                      child: const Text("Disconnect"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                _isConnected
                    ? StreamBuilder(
                        stream: _channel!.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const Center(
                              child: Text("Connection Closed !"),
                            );
                          }
                          //? Working for single frames
                          return Image.memory(
                            Uint8List.fromList(
                              base64Decode(
                                (snapshot.data.toString()),
                              ),
                            ),
                            gaplessPlayback: true,
                          );
                        },
                      )
                    : const Text("Initiate Connection")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
