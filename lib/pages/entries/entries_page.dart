import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_log/custom_classes/custom_clipper.dart';
import 'package:volunteer_log/data_objects/event_data.dart';

import 'package:volunteer_log/custom_classes/custom_expansion_tile.dart';
import 'package:volunteer_log/theme.dart';
import 'package:volunteer_log/custom_classes/custom_cupertino_page_route.dart';

import 'package:volunteer_log/main.dart';
import '../../persistent_data.dart';
import 'manage_entry_screen.dart';

final entriesPageScaffoldKey = GlobalKey<ScaffoldState>();

class EntriesPage extends StatefulWidget {
  final EventData event;

  EntriesPage(this.event);

  @override
  State<StatefulWidget> createState() => _EntriesPageState(this.event);
}

class _EntriesPageState extends State<EntriesPage> {
  EventData event;

  _EntriesPageState(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: entriesPageScaffoldKey,
      appBar: AppBar(
        title: Row(children: [
          Opacity(
            opacity: 0.6,
            child: Text(
              "Entries: ",
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          Text(
            "${event.name}",
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ]),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_3),
            onPressed: (() {
              changeBrightness(context);
            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("Record Entry"),
        onPressed: () async {
          await Navigator.push(
              context,
              NewCupertinoPageRoute(
                  builder: (BuildContext context) =>
                      ManageEntryScreen("Record", event)));
          setState(() {});
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            StadiumBorder(side: BorderSide())),
        elevation: 8,
        notchMargin: 6.0,
        child: Container(
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 14),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    "Total Time: ",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${event.refreshHourMin().hour}",
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(fontSize: 20),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        " ${event.refreshHourMin().hour == 1 ? "hour" : "hours"} ",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Text(
                      "${event.refreshHourMin().min}",
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(fontSize: 20),
                    ),
                    Opacity(
                      opacity: 0.6,
                      child: Text(
                        " ${event.refreshHourMin().min == 1 ? "minute" : "minutes"} ",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: event.entries.length == 0
            ? Center(child: Text("Add an event with the button below"))
            : ListView.builder(
                itemCount: event.entries.length,
                itemBuilder: (context, index) {
                  var entries = event.entries;
                  var entry = entries[index];
                  return Dismissible(
                    key: ValueKey(entry),
                    background: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        )),
                    secondaryBackground: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        color: Colors.red,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        )),
                    child: ClipRRect(
                      clipper: CustomRRect(),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        color: themeColor,
                        child: CustomExpansionTile(
                          tilePadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          expandedAlignment: Alignment.bottomLeft,
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text:
                                          "${daysOfTheWeek[entry.date.weekday]}, ",
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    TextSpan(
                                      text:
                                          "${monthsOfTheYear[entry.date.month]} ${entry.date.day}, ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white.withOpacity(0.9)),
                                    ),
                                    TextSpan(
                                      text: "${entry.date.year}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white.withOpacity(0.8)),
                                    )
                                  ]),
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "from ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Colors.white.withOpacity(0.8))),
                                  TextSpan(
                                      text:
                                          "${entry.startTime.getString(false)}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  TextSpan(
                                      text: " to ",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Colors.white.withOpacity(0.8))),
                                  TextSpan(
                                      text: "${entry.endTime.getString(false)}",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ]))
                              ]),
                          expandedCrossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    entry.description,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    confirmDismiss: (DismissDirection dismissDirection) async {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm"),
                              content: Column(
                                children: [
                                  Text(
                                      "Are you sure you want to delete the following entry?\n",
                                      textAlign: TextAlign.start),
                                  Text(
                                    "${daysOfTheWeek[entry.date.weekday]}, ${monthsOfTheYear[entry.date.month]} ${entry.date.day}, ${entry.date.year}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                mainAxisSize: MainAxisSize.min,
                              ),
                              actions: [
                                CupertinoButton(
                                  child: Text("No, keep it"),
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                ),
                                CupertinoButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  child: Text("Yes, remove it"),
                                  color: themeColor,
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          });
                    },
                    onDismissed: (DismissDirection direction) {
                      var removedIndex = event.entries.indexOf(entry);

                      var scaffoldState = entriesPageScaffoldKey.currentState;
                      scaffoldState.showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Deleted Event \"${entry.description}\"",
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        action: SnackBarAction(
                          onPressed: () {
                            scaffoldState.hideCurrentSnackBar();
                            event.entries.insert(removedIndex, entry);
                            setState(() {});
                          },
                          label: "Undo",
                        ),
                        duration: Duration(seconds: 1),
                      ));

                      setState(() {
                        event.entries.remove(entry);
                        saveData();
                      });
                    },
                  );
                },
              ),
      ),
    );
  }
}
