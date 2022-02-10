import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:stockadvisor/widgets/cupertino/bottom_bar.dart';

class CupertinoSettingsMainScreen extends StatefulWidget {
  static const routeName = "/settings";
  @override
  _CupertinoSettingsMainScreenState createState() =>
      _CupertinoSettingsMainScreenState();
}

class _CupertinoSettingsMainScreenState
    extends State<CupertinoSettingsMainScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        // change depending on selected color
        brightness:
            provider.isDarkModeEnabled ? Brightness.dark : Brightness.light,
        // Try removing opacity to observe the lack of a blur effect and of sliding content.
        // holy shittt that's exactly what i wanted (add it to bottom bar)
        backgroundColor: provider.isDarkModeEnabled
            ? kCupertinoDarkNavColor.withOpacity(0.7)
            : kCupertinoLightNavColor.withOpacity(0.7),
        middle: const Text('Settings'),
        // leading: CircleAvatar(backgroundColor: Colors.amber,),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: CupertinoColors.darkBackgroundGray,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dark Theme"),
                        CupertinoSwitch(
                          activeColor: kGreenColor,
                          value: provider.isDarkModeEnabled,
                          onChanged: (value) {
                            setState(() {
                              provider.isDarkModeEnabled =
                                  !provider.isDarkModeEnabled;
                              provider.isDarkModeEnabled =
                                  provider.isDarkModeEnabled;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  height: 50),
            ),
          ],
        ),
      ),
    );
  }
}
