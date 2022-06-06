import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

final channel =
    IOWebSocketChannel.connect(Uri.parse('wss://streamer.finance.yahoo.com/'));
final channelController = StreamController.broadcast();
late StreamSubscription channelSubscriber;

void main() async {
  final ticker = 'AAPL';
  channelController.addStream(channel.stream);
  channel.sink.add('{"subscribe":["$ticker"]}');
  // var channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:1234'));
  // channel.stream.listen((message) {
  //   channel.sink.add('received!');
  //   channel.sink.close(status.goingAway);
  // });

  channelSubscriber = channelController.stream.listen((data) {
    print(data);
  });
}
