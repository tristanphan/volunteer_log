import 'package:volunteer_log/data_objects/event_data.dart';

import '../main.dart';

void sortVolunteeringEvents() {
  eventCards.sort((a, b) {
    if (a.name != b.name) {
      return a.name.compareTo(b.name);
    }
    return a.refreshTotalHours().compareTo(b.refreshTotalHours());
  });
}

void sortHours(EventData event) {
  event.entries.sort((a, b) {
    if (a.date != b.date) {
      return b.date.compareTo(a.date);
    }
    return b.startTime.getMinutes().compareTo(a.startTime.getMinutes());
  });
}