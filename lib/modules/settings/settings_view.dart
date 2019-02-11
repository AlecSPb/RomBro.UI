import 'package:flutter/material.dart';
import 'package:rombro/helpers/config.dart';

class SettingsViewData extends StatefulWidget {
  SettingsViewData({Key key}) : super(key: key);

  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

ConfigHelper helper = ConfigHelper();

class _SettingsViewState extends State<SettingsViewData> {
  final txt = new TextEditingController();

  _SettingsViewState() {
    print("endpoint: ${helper.endpoint}");
    txt.text = helper.endpoint;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(children: <Widget>[
          Text("Endpoint:", style: TextStyle(color: Colors.grey)),
          Card(
              child: Row(children: <Widget>[            
            Expanded(
                child: TextField(
              controller: txt,
              onChanged: (text) => helper.endpoint = text,
              decoration: const InputDecoration(
                  border: InputBorder.none,                  
                  hintStyle: TextStyle(color: Colors.grey)),
              style: TextStyle(color: Colors.grey),
            ))
          ]))
        ]),
        appBar: new AppBar(
          title: new Text(
            'Settings',
            style: new TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS
                  ? 17.0
                  : 20.0,
            ),
          ),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ));
  }
}