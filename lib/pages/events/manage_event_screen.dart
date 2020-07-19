import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_log/data_objects/event_data.dart';
import 'package:volunteer_log/tools/make_snackbar.dart';
import 'package:volunteer_log/tools/sort_data.dart';

import 'package:volunteer_log/main.dart';
import 'package:volunteer_log/theme.dart';
import '../../persistent_data.dart';
import 'events_page.dart';

class ManageEventScreen extends StatefulWidget {
  final action;

  ManageEventScreen(this.action);

  @override
  _ManageEventScreenState createState() {
    return new _ManageEventScreenState(this.action);
  }
}

class _ManageEventScreenState extends State<ManageEventScreen> {
  var action;

  _ManageEventScreenState(this.action);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController name = new TextEditingController();
    TextEditingController description = new TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Event"),
          actions: [IconButton(
            icon: Icon(Icons.brightness_3),
            onPressed: (() {
              changeBrightness(context);
            }) ,
          )],
        ),
        body: GestureDetector(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: TextFormField(
                        controller: name,
                        decoration: InputDecoration(
                          icon: Icon(Icons.label),
                          labelText: "Event Name",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: themeColor),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        maxLength: 20,
                        style: TextStyle(fontSize: 20),
                        validator: (value) {
                          if (value.isEmpty)
                            return "Event name must not be empty.";
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: TextFormField(
                        controller: description,
                        decoration: InputDecoration(
                          icon: Icon(Icons.assignment),
                          labelText: "Description",
                          hintText: " Optional",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: BorderSide(color: themeColor),
                          ),
                        ),
                        maxLength: 50,
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 2,
                      ),
                    ),
                  ],
                )
            )
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        notchMargin: 6,
        shape: AutomaticNotchedShape(
            RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
            StadiumBorder(side: BorderSide())
        ),
        child: Row(
          children: [CupertinoButton(
            child: Text("Cancel", style: TextStyle(color: Colors.red),),
            onPressed: () => Navigator.pop(context, false),
          ),],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("${this.action} Event"),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Navigator.pop(context, true);
            makeSnackBar(eventsPageScaffoldKey.currentState,
                "Created Event \"${name.text}\"", 2);
            eventCards.add(EventData(name.text, description.text));
            sortVolunteeringEvents();
            saveData();
            setState(() {});
          }
        },
      ),
//      resizeToAvoidBottomPadding: false,
    );
  }
}
