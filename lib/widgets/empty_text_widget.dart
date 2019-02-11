import 'package:flutter/material.dart';

class EmptyTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text('Looks pretty empty here...',
                style: TextStyle(
                    color: Colors.white, fontStyle: FontStyle.italic))));
  }
}