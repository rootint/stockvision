import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData materialLightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    brightness: Brightness.light,
  );
}

ThemeData materialDarkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    brightness: Brightness.dark,
  );
}

CupertinoThemeData cupertinoLightThemeData(BuildContext context) {
  return CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    textTheme: CupertinoTextThemeData(
      tabLabelTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        height: 1,
      ),
    ),
    barBackgroundColor: kCupertinoLightNavColor.withOpacity(0.7),
  );
}

CupertinoThemeData cupertinoDarkThemeData(BuildContext context) {
  return CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    textTheme: CupertinoTextThemeData(
      tabLabelTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        height: 1,
      ),
      navActionTextStyle: TextStyle().copyWith(
        color: kPrimaryColor,
        fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        fontSize: 17,
      ),
      textStyle: TextStyle(letterSpacing: 0.04),
    ),
    scaffoldBackgroundColor: kBlackColor.withOpacity(0.9),
    // fantastic!!!! vvvv
    // barBackgroundColor: CupertinoColors.systemBackground.withOpacity(0.1),
    // barBackgroundColor: CupertinoColors.black.withOpacity(0.6),
    barBackgroundColor: kCupertinoDarkNavColor.withOpacity(0.7),
  );
}
