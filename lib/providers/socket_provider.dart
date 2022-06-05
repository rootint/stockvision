import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/models/yahoo_models/socket_data.dart';
import 'package:web_socket_channel/io.dart';

class SocketProvider extends ChangeNotifier {
  final channel = IOWebSocketChannel.connect(
      Uri.parse('wss://streamer.finance.yahoo.com/'));
  final channelController = StreamController.broadcast();

  SocketProvider() {
    channelController.addStream(channel.stream);
  }

  void subscribeToWebsocket(String ticker) {
    channel.sink.add('{"subscribe":["$ticker"]}');
    print('ok $ticker');
  }

  void unsubscribeFromWebsocket(String ticker) {
    channel.sink.add('{"unsubscribe":["$ticker"]}');
    print('removed $ticker');
  }

  // YahooHelperSocketData getSocketData(String ticker) {

  // }

}
