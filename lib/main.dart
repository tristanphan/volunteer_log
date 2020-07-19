import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:volunteer_log/persistent_data.dart';
import 'package:volunteer_log/theme.dart';

import 'pages/events/events_page.dart';
import 'data_objects/event_data.dart';

void main() {
  runApp(MyApp());
}

var allIdentifiers = <String>[];
var eventCards = <EventData>[];
Brightness brightness;

//double getWidth(context) => MediaQuery.of(context).size.width;
//double getHeight(context) => MediaQuery.of(context).size.height;
var daysOfTheWeek = <String>["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
var monthsOfTheYear = <String>["", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
var abbreviatedMonthsOfTheYear = <String>["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    loadDataWithBrightness();
    return DynamicTheme(
      defaultBrightness: brightness,
      data: (brightness) {
        if (brightness == Brightness.light) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          return ThemeData(
            primarySwatch: primarySwatchLight,
            accentColor: accentColorLight,
            primaryColor: themeColorLight,
            brightness: brightness,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          );
        }
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        return ThemeData(
          primarySwatch: primarySwatchDark,
          accentColor: accentColorDark,
          primaryColor: themeColorDark,
          brightness: brightness,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Volunteer Log',
          theme: theme,
          home: EventsPage(),
        );
      },
    );
  }
}
