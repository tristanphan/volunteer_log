import 'package:volunteer_log/tools/time_of_the_day.dart';

class EntryData {
  DateTime date;
  String description;
  TimeOfTheDay startTime;
  TimeOfTheDay endTime;

  EntryData(this.date, this.description, this.startTime, this.endTime);

  Map toJson() => {
        'description': this.description,
        'date': {
          'year': this.date.year,
          'month': this.date.month,
          'day': this.date.day,
        },
        'start_time': {
          'hour': this.startTime.hour,
          'minute': this.startTime.min,
        },
        'end_time': {
          'hour': this.endTime.hour,
          'minute': this.endTime.min,
        },
      };
}
