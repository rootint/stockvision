import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:provider/provider.dart';
import 'package:stockadvisor/helpers/route.dart';
import 'package:stockadvisor/providers/chart_provider.dart';
import 'package:stockadvisor/providers/data_provider.dart';
import 'package:stockadvisor/providers/info_provider.dart';
import 'package:stockadvisor/providers/server/holdings_provider.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/providers/server/watchlist_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/dashboard/material_main_screen.dart';
import 'package:stockadvisor/screens/holdings/cupertino/alltime_provider.dart';
import 'package:stockadvisor/theme.dart';

bool get isiOS =>
    foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // if (isiOS) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
        ChangeNotifierProvider<ChartProvider>(create: (_) => ChartProvider()),
        ChangeNotifierProvider<InfoProvider>(create: (_) => InfoProvider()),
        ChangeNotifierProvider<WatchlistProvider>(
            create: (_) => WatchlistProvider()),
        ChangeNotifierProvider<PredictionProvider>(
            create: (_) => PredictionProvider()),
        ChangeNotifierProvider<AllTimeProvider>(
            create: (_) => AllTimeProvider()),
        ChangeNotifierProxyProvider<DataProvider, HoldingsProvider>(
          create: (_) => HoldingsProvider(),
          update: (_, data, holdings) => holdings!..update(data),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: provider.isDarkModeEnabled
                ? cupertinoDarkThemeData(context)
                : cupertinoLightThemeData(context),
            routes: RouteHelper.routes,
          );
        },
      ),
    );
    // } else {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: materialDarkThemeData(context),
    //   // theme: materialLightThemeData(context),
    //   home: MaterialDashboardMainScreen(),
    // );
    // }
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:stockadvisor/protobuf/message.pbjson.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:protobuf/protobuf.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import 'package:stockadvisor/protobuf/message.pb.dart';
// import 'package:stockadvisor/protobuf/message.pbenum.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp();

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     final channel = IOWebSocketChannel.connect(
//         Uri.parse('wss://streamer.finance.yahoo.com/'));
//     channel.sink.add('{"subscribe":["AAPL"]}');
//     return MaterialApp(
//       title: 'Welcome to Flutter',
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Welcome to Flutter'),
//         ),
//         body: StreamBuilder(
//           stream: channel.stream,
//           builder: (context, snapshot) {
//             var dick =
//                 yaticker.fromBuffer(base64.decode(snapshot.data.toString()));
//             return Text(snapshot.hasData ? dick.toString() : '');
//           },
//         ),
//       ),
//     );
//   }
// }
