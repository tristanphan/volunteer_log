import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:volunteer_log/data_objects/event_data.dart';
import 'package:volunteer_log/tools/sort_data.dart';
import 'package:volunteer_log/tools/time_of_the_day.dart';

import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveData() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  List<Map> events = <Map>[];
  eventCards.forEach((event) => events.add(event.toJson()));

  sharedPreferences.setString('events', jsonEncode(events));

  sharedPreferences.setBool('isDark', true);
}

Future<bool> loadData() async {
  bool returnVal = false;
  final sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.containsKey('events')) {
    String eventsString = sharedPreferences.getString('events');
    List events = jsonDecode(eventsString);
    eventCards.clear();
    events.forEach((event) {
      assert (event is Map);
      eventCards.add(EventData(event['name'], event['description']));
      List entries = event['entries'];
      entries.forEach((entry) {
        eventCards[eventCards.length - 1].addEntry(DateTime(
            entry['date']['year'], entry['date']['month'], entry['date']['day']),
            entry['description'], TimeOfTheDay(
                entry['start_time']['hour'], entry['start_time']['minute']),
            TimeOfTheDay(entry['end_time']['hour'], entry['end_time']['minute']));
      });
    });
    returnVal = true;
  }


  sortVolunteeringEvents();
  eventCards.forEach((event) {
    sortHours(event);
  });
  if (sharedPreferences.containsKey('isDark')) {
    brightness = sharedPreferences.getBool('isDark')? Brightness.dark: Brightness.light;
  }
  return returnVal;
}

void loadDataWithBrightness() async {
  loadData();
}