import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MarioLoadingWidget extends StatelessWidget {
  MarioLoadingWidget();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: FlareActor("assets/mario.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled")));
  }
}
