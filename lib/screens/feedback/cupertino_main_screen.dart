import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/providers/theme_provider.dart';

class CupertinoFeedbackMainScreen extends StatelessWidget {
  const CupertinoFeedbackMainScreen({ Key? key }) : super(key: key);

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
        middle: const Text('Feedback'),
        // leading: CircleAvatar(backgroundColor: Colors.amber,),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container()
      ),
    );
  }
}