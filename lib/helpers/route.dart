import 'package:stockadvisor/main/cupertino_main_screen.dart';
import 'package:stockadvisor/screens/dashboard/cupertino_main_screen.dart';
import 'package:stockadvisor/screens/holdings/cupertino/main_screen.dart';
import 'package:stockadvisor/screens/search/cupertino/main_screen.dart';
import 'package:stockadvisor/screens/stock_overview/cupertino/main_screen.dart';

class RouteHelper {
  static final routes = {
    '/': (ctx) => CupertinoMainScreen(),
    CupertinoDashboardMainScreen.routeName: (ctx) =>
        CupertinoDashboardMainScreen(),
    CupertinoStockOverviewMainScreen.routeName: (ctx) =>
        CupertinoStockOverviewMainScreen(),
    CupertinoHoldingsMainScreen.routeName: (ctx) =>
        CupertinoHoldingsMainScreen(),
    CupertinoSearchMainScreen.routeName: (ctx) =>
        CupertinoSearchMainScreen(),
  };
  
  static final settingsRoutes = {};
}
