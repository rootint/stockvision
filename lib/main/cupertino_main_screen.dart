import 'package:flutter/cupertino.dart';
import 'package:stockadvisor/helpers/route.dart';
import 'package:stockadvisor/screens/dashboard/cupertino_main_screen.dart';
import 'package:stockadvisor/screens/feedback/cupertino_main_screen.dart';
import 'package:stockadvisor/screens/holdings/cupertino/main_screen.dart';
import 'package:stockadvisor/screens/notifications/cupertino/main_screen.dart';
import 'package:stockadvisor/screens/settings/cupertino_main_screen.dart';

class CupertinoMainScreen extends StatelessWidget {
  CupertinoMainScreen({Key? key}) : super(key: key);

  final CupertinoTabController tabController = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: 'Holdings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.lightbulb),
            label: 'Council',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.slider_horizontal_3),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                  routes: RouteHelper.routes,
                  builder: (context) {
                    // Navigator.popUntil(context, ModalRoute.withName('/'));
                    return const CupertinoDashboardMainScreen();
                    // return CupertinoNotificationsMainScreen();
                  },
                );
              case 1:
                return CupertinoTabView(
                  routes: RouteHelper.routes,
                  builder: (context) => const CupertinoHoldingsMainScreen(),
                );
              case 2:
                return CupertinoTabView(
                  routes: RouteHelper.routes,
                  builder: (context) => const CupertinoNotificationsMainScreen(),
                );
              case 3:
                return CupertinoTabView(
                  routes: RouteHelper.routes,
                  builder: (context) => const CupertinoFeedbackMainScreen(),
                );
              case 4:
                return CupertinoTabView(
                  routes: RouteHelper.routes,
                  builder: (context) => CupertinoSettingsMainScreen(),
                );
            }
            return CupertinoTabView(
              routes: RouteHelper.routes,
              builder: (context) => const CupertinoDashboardMainScreen(),
            );
          },
        );
      },
      controller: tabController,
    );
  }
}
