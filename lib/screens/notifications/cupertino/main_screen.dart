import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/server/prediction_provider.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/screens/notifications/cupertino/prediction_card.dart';
import 'package:stockadvisor/screens/notifications/cupertino/today_prediction_block.dart';
import 'package:stockadvisor/widgets/cupertino/prediction_ticker_card.dart';

class CupertinoNotificationsMainScreen extends StatefulWidget {
  static const routeName = "/notifications";
  const CupertinoNotificationsMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoNotificationsMainScreen> createState() =>
      _CupertinoNotificationsMainScreenState();
}

class _CupertinoNotificationsMainScreenState
    extends State<CupertinoNotificationsMainScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final predictionProvider = Provider.of<PredictionProvider>(context);
    final currentPredictions = predictionProvider.predictions;
    final predictionHistory = predictionProvider.predictionHistory;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: isDarkModeEnabled ? Brightness.dark : Brightness.light,
        backgroundColor: isDarkModeEnabled
            ? kCupertinoDarkNavColor.withOpacity(0.7)
            : kCupertinoLightNavColor.withOpacity(0.7),
        middle: const Text('Predictions'),
        // trailing: CupertinoButton(
        //     padding: EdgeInsets.zero,
        //     onPressed: () {},
        //     child: const Icon(CupertinoIcons.list_bullet,
        //         color: CupertinoColors.white)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoTodayPredictionBlock(currentPredictions),
                  const SizedBox(height: 16),
                  const Text(
                    "History",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }
            return CupertinoNotificationPredictionCard(
              data: predictionHistory[index - 1],
            );
          },
          itemCount: predictionHistory.length + 1,
        ),
      ),
    );
  }
}
