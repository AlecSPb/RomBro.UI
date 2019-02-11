import 'package:flutter/material.dart';

enum MessageType { Success, Error }

class SnackBarHelper {
  static void showSnackBar(
      BuildContext context, String message, MessageType messageType,
      [Duration duration = const Duration(seconds: 3)]) {
    Color color;
    if (messageType == MessageType.Success)
      color = Colors.greenAccent;
    else
      color = Colors.redAccent;

    var snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: duration,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
