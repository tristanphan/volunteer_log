import 'package:flutter/material.dart';

void makeSnackBar(ScaffoldState scaffoldState, String display, int seconds) {
  scaffoldState.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(display, overflow: TextOverflow.fade, softWrap: false,),
    action: SnackBarAction(
      onPressed: () => scaffoldState.hideCurrentSnackBar(),
      label: "Dismiss",
    ),
    duration: Duration(seconds: seconds),
  ));
}