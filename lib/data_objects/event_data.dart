import 'package:volunteer_log/persistent_data.dart';
import 'package:volunteer_log/tools/sort_data.dart';
import 'package:volunteer_log/tools/time_of_the_day.dart';

import 'entry_data.dart';

class EventData {
  String name;
  String description;

  EventData(this.name, this.description);

  double totalHours = 0.0;
  var entries = <EntryData>[];

  void addEntry(DateTime date, String description, TimeOfTheDay startTime, TimeOfTheDay endTime) {
    entries.add(EntryData(date, description, startTime, endTime));
    sortHours(this);
    saveData();
  }

  double refreshTotalHours() {
    totalHours = 0;
    entries.forEach((element) {
      totalHours += double.parse((element.startTime - element.endTime)
              .getMinutes()
              .toStringAsFixed(1)) /
          60;
    });
    return totalHours;
  }

  TimeOfTheDay refreshHourMin() {
    this.refreshTotalHours();
    int hours = 0, mins = 0;
    this.entries.forEach((element) {
      hours += (double.parse((element.startTime - element.endTime)
                  .getMinutes()
                  .toStringAsFixed(1)) /
              60)
          .truncate();
      mins += (double.parse((element.startTime - element.endTime)
                  .getMinutes()
                  .toStringAsFixed(1)) -
              (double.parse((element.startTime - element.endTime)
                              .getMinutes()
                              .toStringAsFixed(1)) /
                          60)
                      .truncate() *
                  60)
          .toInt();
    });
    return TimeOfTheDay(hours, mins);
  }

  Map toJson() {
    List<Map> entries = <Map>[];
    this.entries.forEach((entry) => entries.add(entry.toJson()));

    return {
      'name': this.name,
      'description': this.description,
      'entries': entries,
    };
  }
}
