import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:stockadvisor/protobuf/message.pb.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final channel = IOWebSocketChannel.connect(
        Uri.parse('wss://streamer.finance.yahoo.com/'));
    // channel.sink.add('{"subscribe":["AAPL","MSFT"]}');
    channel.sink.add('{"subscribe":["MSFT"]}');
    channel.sink.add('{"subscribe":["AAPL"]}');
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            // print(snapshot.data);
            if (snapshot.hasData) {
              var dick =
                  yaticker.fromBuffer(base64.decode(snapshot.data.toString()));
              // var parsed = jsonDecode(dick.toProto3Json().toString());
              // var parsed = dick.writeToJsonMap();
              // print(parsed["1"]);
              // print(jsonDecode(dick.writeToJson()));
              print(dick.id);
              return Text(dick.toString());
            }
            return const Text('');
          },
        ),
      ),
    );
  }
}
