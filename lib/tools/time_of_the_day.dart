class TimeOfTheDay {
  int hour;
  int min;
  TimeOfTheDay(this.hour,this.min);
  String getString(bool is24hr) {
    String hourX = this.hour == 0 ? "12" : this.hour.toString();
    String minX = this.min.toString().length == 2 ? this.min.toString() : "0" + this.min.toString();
    if (is24hr) return "$hourX:$minX";

    var tempHour = this.hour;
    var pm = tempHour > 12;
    if (pm) tempHour -= 12;
    if (this.hour == 12) pm = !pm;
    String hourY = tempHour == 0 ? "12" : tempHour.toString();
    String minY = this.min.toString().length == 2 ? this.min.toString() : "0" + this.min.toString();
    return "$hourY:$minY ${pm ? "PM" : "AM"}";
  }

  int getMinutes() {
    return hour*60 + min;
  }

  TimeOfTheDay operator -(TimeOfTheDay other) {
    var minutesApart = (other.getMinutes() - this.getMinutes()).abs();
    var hoursApart = 0;
    while (minutesApart >= 60) { hoursApart += 1; minutesApart -= 60; }
    return TimeOfTheDay(hoursApart, minutesApart);
  }
}