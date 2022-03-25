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
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/dashboard/material_main_screen.dart';
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
