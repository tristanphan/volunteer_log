import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:volunteer_log/custom_classes/custom_daynight_timepicker.dart';
import 'package:volunteer_log/data_objects/event_data.dart';
import 'package:volunteer_log/tools/make_snackbar.dart';
import 'package:volunteer_log/tools/time_of_the_day.dart';

import 'package:volunteer_log/main.dart';
import 'package:volunteer_log/theme.dart';
import 'entries_page.dart';

class ManageEntryScreen extends StatefulWidget {
  final String action;
  final EventData event;

  ManageEntryScreen(this.action, this.event);

  @override
  State<StatefulWidget> createState() =>
      _ManageEntryScreenState(this.action, this.event);
}

class _ManageEntryScreenState extends State<ManageEntryScreen> {
  String _description;
  DateTime _dateTime;
  TimeOfDay _startTime = TimeOfDay(hour: 11, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 15, minute: 0);

  final manageEntryScaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String action;
  EventData event;

  _ManageEntryScreenState(this.action, this.event);

  var controller = TextEditingController();
  Color _descriptionIsNullColor;
  Color _dateTimeIsNullColor;
  Color _startTimeIsNullColor;
  Color _endTimeIsNullColor;

  @override
  Widget build(BuildContext context) {
    if (_descriptionIsNullColor == null) {
      _descriptionIsNullColor = Theme.of(context).cardColor;
      _dateTimeIsNullColor = Theme.of(context).cardColor;
      _startTimeIsNullColor = Theme.of(context).cardColor;
      _endTimeIsNullColor = Theme.of(context).cardColor;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: manageEntryScaffoldKey,
      appBar: AppBar(
        title: Text("${this.action} Entry"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_3),
            onPressed: (() {
              changeBrightness(context);
            }),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side:
                          BorderSide(color: _dateTimeIsNullColor, width: 2.0)),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: _dateTime == null
                                ? Opacity(
                                    opacity: 0.6,
                                    child: Text(
                                      "No date selected",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                : Text(
                                    "${daysOfTheWeek[_dateTime.weekday]}\n${abbreviatedMonthsOfTheYear[_dateTime.month]} ${_dateTime.day}, ${_dateTime.year}",
                                    style: TextStyle(fontSize: 20),
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  )),
                        SizedBox(
                          child: CupertinoButton(
                            color: themeColor,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Pick Date",
                                style: TextStyle(fontSize: 17)),
                            onPressed: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              var now = DateTime.now();
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(
                                  now.year - 7,
                                ),
                                lastDate: DateTime.utc(now.year + 7, 12, 31),
                              ).then((date) {
                                setState(() => _dateTime = date);
                              });
                            },
                          ),
                          width: 150,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: [_startTime, _endTime].contains(null)
                        ? BorderSide(color: _startTimeIsNullColor, width: 2.0)
                        : ((_endTime.hour + _endTime.minute / 60.0) >=
                                (_startTime.hour + _startTime.minute / 60.0)
                            ? BorderSide(
                                color: _startTimeIsNullColor, width: 2.0)
                            : BorderSide(color: Colors.red, width: 2)),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text(
                          "Pick Start Time",
                          style: TextStyle(fontSize: 22),
                        ),
                        DayNightTimePicker(
                          value: TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
                          onChange: (TimeOfDay date) {
                            _startTime = date;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: [_startTime, _endTime].contains(null)
                        ? BorderSide(color: _endTimeIsNullColor, width: 2.0)
                        : ((_endTime.hour + _endTime.minute / 60.0) >=
                                (_startTime.hour + _startTime.minute / 60.0)
                            ? BorderSide(color: _endTimeIsNullColor, width: 2.0)
                            : BorderSide(color: Colors.red, width: 2)),
                  ),
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text(
                          "Pick End Time",
                          style: TextStyle(fontSize: 22),
                        ),
                        DayNightTimePicker(
                          value: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
                          onChange: (TimeOfDay date) {
                            _endTime = date;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                          color: _descriptionIsNullColor, width: 2.0)),
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 15, bottom: 10),
                    child: Form(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          icon: Icon(Icons.label),
                          labelText: "Description",
                          hintText: "Describe what you did.",
                        ),
                        maxLength: 100,
                        maxLines: null,
                        minLines: 2,
                        style: TextStyle(fontSize: 20),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Description must not be empty.";
                          return null;
                        },
                      ),
                      key: _formKey,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
              ])),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        notchMargin: 6,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            StadiumBorder(side: BorderSide())),
        child: Row(
          children: [
            CupertinoButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("${this.action} Entry"),
        onPressed: () {
          _descriptionIsNullColor = Theme.of(context).cardColor;
          _dateTimeIsNullColor = Theme.of(context).cardColor;
          _startTimeIsNullColor = Theme.of(context).cardColor;
          _endTimeIsNullColor = Theme.of(context).cardColor;

          if (_dateTime == null) {
            setState(() {
              _dateTimeIsNullColor = Colors.red;
            });
            return;
          }
          if (_startTime == null) {
            setState(() {
              _startTimeIsNullColor = Colors.red;
            });
            return;
          }
          if (_endTime == null) {
            setState(() {
              _endTimeIsNullColor = Colors.red;
            });
          }
          if ((_endTime.hour + _endTime.minute / 60) <
              (_startTime.hour + _startTime.minute / 60)) {
            setState(() {
              _endTimeIsNullColor = Colors.red;
            });
            return;
          }
          if (_formKey.currentState.validate()) {
            _description = controller.text;
            event.addEntry(
                _dateTime,
                _description,
                TimeOfTheDay(_startTime.hour, _startTime.minute),
                TimeOfTheDay(_endTime.hour, _endTime.minute));
            makeSnackBar(entriesPageScaffoldKey.currentState,
                "Recorded Entry \"$_description\"", 2);
            Navigator.pop(context);
            return;
          }
          setState(() {
            _descriptionIsNullColor = Colors.red;
          });
        },
      ),
    );
  }
}
