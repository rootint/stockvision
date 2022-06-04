import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() async {
  var channel = IOWebSocketChannel.connect(Uri.parse('wss://streamer.finance.yahoo.com/'));
  channel.sink.add('{"subscribe":["AMZN"]}');
  // var channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:1234'));

  channel.stream.listen((message) {
    channel.sink.add('received!');
    channel.sink.close(status.goingAway);
  });
}
