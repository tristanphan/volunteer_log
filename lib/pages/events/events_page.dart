import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_log/custom_classes/custom_cupertino_page_route.dart';
import 'package:volunteer_log/pages/entries/entries_page.dart';
import 'package:volunteer_log/tools/make_snackbar.dart';

import 'package:volunteer_log/main.dart';
import 'package:volunteer_log/theme.dart';
import '../../persistent_data.dart';
import 'manage_event_screen.dart';

final eventsPageScaffoldKey = GlobalKey<ScaffoldState>();

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      key: eventsPageScaffoldKey,
      appBar: AppBar(
        title: Text("Volunteer Log"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_3),
            onPressed: (() {
              changeBrightness(context);
            }),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: eventCards.length == 0
            ? Center(child: Text("Add an event with the button below"))
            : ListView.builder(
                itemCount: eventCards.length,
                itemBuilder: (context, index) {
                  var eventCard = eventCards[index];
                  return Dismissible(
                    key: ValueKey(eventCard),
                    direction: DismissDirection.horizontal,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        color: themeColor,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                NewCupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      EntriesPage(eventCard),
                                ));
                            eventCard.refreshTotalHours();
                            setState(() {});
                          },
                          child: Container(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    eventCard.name,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 0),
                                      child: Column(
                                        children: [
                                          Text(
                                            eventCard
                                                .refreshTotalHours()
                                                .toStringAsFixed(1),
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                          Text(
                                            "Hours",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                height: 0.8),
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 5),
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          color: themeColor,
                                          size: 20,
                                        ),
                                        backgroundColor: Colors.white,
                                        radius: 10,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            padding: EdgeInsets.fromLTRB(15, 10, 5, 10),
                          ),
                        )),
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
                    confirmDismiss: (DismissDirection dismissDirection) async {
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm"),
                              content: Column(
                                children: [
                                  Text(
                                      "Are you sure you want to delete the following event?\n",
                                      textAlign: TextAlign.start),
                                  Text(
                                    eventCard.name,
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
                      var removedIndex = eventCards.indexOf(eventCard);

                      var scaffoldState = eventsPageScaffoldKey.currentState;
                      scaffoldState.showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Deleted Event \"${eventCard.name}\"",
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        action: SnackBarAction(
                          onPressed: () {
                            scaffoldState.hideCurrentSnackBar();
                            eventCards.insert(removedIndex, eventCard);
                            setState(() {});
                          },
                          label: "Undo",
                        ),
                        duration: Duration(seconds: 1),
                      ));

                      setState(() {
                        eventCards.remove(eventCard);
                        saveData();
                      });
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
                context,
                NewCupertinoPageRoute<bool>(
                    builder: (BuildContext context) =>
                        ManageEventScreen("Create")));
            setState(() {});
          },
          label: Text("Create Event"),
          icon: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              StadiumBorder(side: BorderSide())),
          elevation: 8,
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    makeSnackBar(eventsPageScaffoldKey.currentState, "test", 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_circle),
                        Container(height: 3),
                        Text("Profile")
                      ],
                    ),
                  ),
                ),
              ),
              Container(width: 200, height: 0),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    makeSnackBar(eventsPageScaffoldKey.currentState, "set", 1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.settings),
                        Container(height: 3),
                        Text("Settings")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
