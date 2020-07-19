import 'dart:ui';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';

import 'custom_ampm.dart';
import 'custom_daynight_banner.dart';

const _BORDER_RADIUS = 15.0;

class DayNightTimePicker extends StatefulWidget {
  final TimeOfDay value;
  final void Function(TimeOfDay) onChange;
  final bool is24HrFormat;
  final Color accentColor;
  final String cancelText;
  final String okText;
  final Image sunAsset;
  final Image moonAsset;
  final bool blurredBackground;

  DayNightTimePicker({
    Key key,
    @required this.value,
    @required this.onChange,
    this.is24HrFormat = false,
    this.accentColor,
    this.cancelText = "cancel",
    this.okText = "ok",
    this.sunAsset,
    this.moonAsset,
    this.blurredBackground = false,
  }) : super(key: key);

  @override
  _DayNightTimePickerState createState() => _DayNightTimePickerState();
}

class _DayNightTimePickerState extends State<DayNightTimePicker> {
  int hour;
  int minute;
  String a;

  bool changingHour = true;

  final okCancelStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  void initState() {
    separateHoursAndMinutes();
    super.initState();
  }

  @override
  void didUpdateWidget(DayNightTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.is24HrFormat != widget.is24HrFormat ||
        oldWidget.value != widget.value) {
      separateHoursAndMinutes();
    }
  }

  void separateHoursAndMinutes() {
    int _h = widget.value.hour;
    int _m = widget.value.minute;
    String _a = "am";

    if (!widget.is24HrFormat) {
      if (_h == 0) {
        _h = 12;
      } else if (_h == 12) {
        _a = "pm";
      } else if (_h > 12) {
        _a = "pm";
        _h -= 12;
      }
    }
    setState(() {
      hour = _h;
      minute = _m;
      a = _a;
    });
  }

  onChangeTime(double value) {
    if (changingHour) {
      setState(() {
        hour = value.round();
      });
    } else {
      setState(() {
        minute = value.round();
      });
    }
    var time = TimeOfDay(
      hour: getHours(hour, a, widget.is24HrFormat),
      minute: minute,
    );
    widget.onChange(time);
  }

  changeCurrentSelector(bool isHour) {
    setState(() {
      changingHour = isHour;
    });
  }

  onOk() {
    var time = TimeOfDay(
      hour: getHours(hour, a, widget.is24HrFormat),
      minute: minute,
    );
    widget.onChange(time);
    onCancel();
  }

  onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _commonTimeStyles = Theme.of(context).textTheme.display3.copyWith(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        );

    double min = 0;
    double max = 59;
    int divisions = 59;
    double hourMinValue = 1;
    double hourMaxValue = 12;
    if (changingHour) {
      min = 1;
      max = 12;
      divisions = 11;
      if (widget.is24HrFormat) {
        min = 0;
        max = 23;
        divisions = 23;
        hourMinValue = 0;
        hourMaxValue = 23;
      }
    }

    final height = widget.is24HrFormat ? 200.0 : 90.0;

    final color = widget.accentColor ?? Theme.of(context).accentColor;
    final unselectedOpacity = 1.0;

    final double blurAmount = widget.blurredBackground ?? false ? 5 : 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
      ),
      elevation: 12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DayNightBanner(
              hour: getHours(hour, a, widget.is24HrFormat),
              displace: mapRange(hour * 1.0, hourMinValue, hourMaxValue),
              sunAsset: widget.sunAsset,
              moonAsset: widget.moonAsset,
            ),
            Container(
                height: height,
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.only(left: 12.0, top: 5.0, right: 12.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: AmPm(
                              accentColor: color,
                              selected: a,
                              onChange: (e) {
                                setState(() {
                                  a = e;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: InkWell(
                                      onTap: () {
                                        changeCurrentSelector(true);
                                      },
                                      child: Opacity(
                                        opacity:
                                            changingHour ? 1 : unselectedOpacity,
                                        child: Text(
                                          "$hour",
                                          style: _commonTimeStyles.copyWith(
                                              color: changingHour ? color : null),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(":", style: _commonTimeStyles),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      changeCurrentSelector(false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3.0),
                                      child: Opacity(
                                        opacity:
                                            !changingHour ? 1 : unselectedOpacity,
                                        child: Text(
                                          "${padNumber(minute)}",
                                          style: _commonTimeStyles.copyWith(
                                              color: !changingHour ? color : null),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Slider(
                      value: changingHour
                          ? hour.roundToDouble()
                          : minute.roundToDouble(),
                      onChanged: onChangeTime,
                      min: min,
                      max: max,
                      divisions: divisions,
                      activeColor: color,
                      inactiveColor: color.withAlpha(55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
