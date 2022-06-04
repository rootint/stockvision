import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stockadvisor/constants.dart';
import 'package:stockadvisor/helpers/tuple.dart';
import 'package:stockadvisor/providers/theme_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CupertinoFeedbackMainScreen extends StatefulWidget {
  const CupertinoFeedbackMainScreen({Key? key}) : super(key: key);

  @override
  State<CupertinoFeedbackMainScreen> createState() =>
      _CupertinoFeedbackMainScreenState();
}

class _CupertinoFeedbackMainScreenState
    extends State<CupertinoFeedbackMainScreen> {
  final textController = TextEditingController();
  final List<Tuple> _feedbackSuggestions = [
    Tuple("I don't like how the app looks like", false),
    Tuple("The stock data is wrong", false),
    Tuple("I found a bug", false),
    Tuple("The predictions are poor", false),
    Tuple("Other", false),
  ];
  int _currentRating = 0;

  void _sendMessage(BuildContext context) async {
    final deviceInfoPlugin = await DeviceInfoPlugin().deviceInfo;
    final deviceInfo = deviceInfoPlugin.toMap();
    String message = """Rating: $_currentRating\n
    Feedback Suggestions: ${_feedbackSuggestions.map((e) => [
              e.first,
              e.second
            ])}\n
    Message: ${textController.text}\n
    Device Info: $deviceInfo""";
    FocusManager.instance.primaryFocus?.unfocus();
    if (_currentRating == 0) {
      _showNotRatedAlertDialog(context);
      return;
    }
    setState(() {
      _showCompleteAlertDialog(context, _currentRating);
      _currentRating = 0;
      for (var item in _feedbackSuggestions) {
        item.second = false;
      }
      textController.text = '';
    });
    // send the message somewhere
  }

  void _showCompleteAlertDialog(BuildContext context, int rating) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Thank you!'),
        content: Text(
          rating > 3
              ? 'We will continue to improve further!'
              : 'We are sorry that you are not satisfied. We will do our best to fix the issues.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotRatedAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        content: const Text(
          'Please leave a rating by clicking the stars.',
          style: TextStyle(fontSize: 14),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkModeEnabled =
        Provider.of<ThemeProvider>(context).isDarkModeEnabled;
    final mediaQuery = MediaQuery.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        brightness: isDarkModeEnabled ? Brightness.dark : Brightness.light,
        backgroundColor: isDarkModeEnabled
            ? kCupertinoDarkNavColor.withOpacity(0.7)
            : kCupertinoLightNavColor.withOpacity(0.7),
        middle: const Text('Feedback'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rate your experience",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      color: isDarkModeEnabled
                          ? CupertinoColors.white
                          : CupertinoColors.black),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < 5; ++i)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          (_currentRating > i)
                              ? CupertinoIcons.star_fill
                              : CupertinoIcons.star,
                          color: kSecondaryColor,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _currentRating = i + 1;
                            FocusManager.instance.primaryFocus?.unfocus();
                            HapticFeedback.lightImpact();
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "What can be improved?",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                      color: isDarkModeEnabled
                          ? CupertinoColors.white
                          : CupertinoColors.black),
                ),
                const SizedBox(height: 15),
                Wrap(
                  children: [
                    for (var i = 0; i < _feedbackSuggestions.length; ++i)
                      RowCard(_feedbackSuggestions[i].first, () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _feedbackSuggestions[i].second =
                              !_feedbackSuggestions[i].second;
                        });
                        HapticFeedback.lightImpact();
                      }, _feedbackSuggestions[i].second, isDarkModeEnabled)
                  ],
                  spacing: 15,
                ),
                const SizedBox(height: 15),
                CupertinoTextField(
                  placeholder: "Don't leave confidential information here.",
                  controller: textController,
                  minLines: 10,
                  maxLines: 20,
                ),
                const SizedBox(height: 15),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kPrimaryColor,
                    ),
                    width: mediaQuery.size.width,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 9),
                      child: Text(
                        "Send",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: CupertinoColors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowCard extends StatelessWidget {
  final String label;
  final Function onPressed;
  final bool isSelected;
  final bool isDarkModeEnabled;
  const RowCard(
      this.label, this.onPressed, this.isSelected, this.isDarkModeEnabled,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => onPressed(),
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 7,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isDarkModeEnabled
                  ? (isSelected
                      ? CupertinoColors.white
                      : CupertinoColors.systemGrey4)
                  : (isSelected
                      ? CupertinoColors.white
                      : CupertinoColors.darkBackgroundGray),
            ),
          ),
        ),
      ),
    );
  }
}
