// import 'package:flutter/cupertino.dart';
// import 'package:stockadvisor/screens/dashboard/cupertino_main_screen.dart';
// import 'package:stockadvisor/screens/feedback/cupertino_main_screen.dart';
// import 'package:stockadvisor/screens/settings/cupertino_main_screen.dart';

// class CupertinoMainScreen extends StatelessWidget {
//   const CupertinoMainScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoTabScaffold(
//       tabBar: CupertinoTabBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.chart_bar),
//             label: 'Dashboard',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.search),
//             label: 'Tickers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.person_alt_circle), // or maybe gear
//             label: 'Council',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.chat_bubble_text),
//             label: 'Feedback',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.slider_horizontal_3),
//             label: 'Settings',
//           ),
//         ],
//       ),
//       tabBuilder: (BuildContext context, int index) {
//         return CupertinoTabView(
//           builder: (BuildContext context) {
//             switch (index) {
//               case 0:
//                 return CupertinoTabView(
//                   builder: (context) => CupertinoDashboardMainScreen(),
//                 );
//               case 1:
//                 return CupertinoTabView(
//                   builder: (context) => CupertinoDashboardMainScreen(),
//                 );
//               case 2:
//                 return CupertinoTabView(
//                   builder: (context) => CupertinoDashboardMainScreen(),
//                 );
//               case 3:
//                 return CupertinoTabView(
//                   builder: (context) => CupertinoFeedbackMainScreen(),
//                 );
//               case 4:
//                 return CupertinoTabView(
//                   builder: (context) => CupertinoSettingsMainScreen(),
//                 );
//             }
//             return CupertinoTabView(
//               builder: (context) => CupertinoDashboardMainScreen(),
//             );
//           },
//         );
//       },
//     );
//   }
// }
