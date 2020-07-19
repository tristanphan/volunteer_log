import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'main.dart';

var primarySwatchLight = Colors.blue;
var accentColorLight = Colors.blueAccent;
var themeColorLight = Colors.blue[600];

var primarySwatchDark = Colors.teal;
var accentColorDark = Colors.tealAccent;
var themeColorDark = Colors.teal[600];

var themeColor = (brightness == Brightness.light)? themeColorLight: themeColorDark;

void changeBrightness(context) {
  DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
  themeColor = DynamicTheme.of(context).brightness == Brightness.dark ? themeColorDark : themeColorLight;
}

void changeColor(context) {
  DynamicTheme.of(context).setThemeData(ThemeData(
      primaryColor: Theme.of(context).primaryColor == Colors.indigo ? Colors.red : Colors.indigo
  ));
}