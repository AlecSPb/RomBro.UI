import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'scripts.dart';

class ScriptListTile extends StatefulWidget {
  final ScriptModel script;
  const ScriptListTile({Key key, this.script}) : super(key: key);
  @override
  ScriptListTileState createState() {
    return new ScriptListTileState();
  }
}

class ScriptListTileState extends State<ScriptListTile> {
  @override
  Widget build(BuildContext context) {
    final scriptsBloc = BlocProvider.of<ScriptsBloc>(context);

    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        leading: Container(
            padding: EdgeInsets.only(right: 20),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 2.0, color: Colors.grey))),
            child: FlutterLogo()),
        title: Text(
          widget.script.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 1, top: 5),
                  child: Text(widget.script.description,
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing: new Column(children: <Widget>[
          new Container(
              child: new IconButton(
                  icon: Icon(Icons.send, color: Colors.white, size: 30.0),
                  onPressed: () {
                    print("send...");
                    scriptsBloc.dispatch(
                        ExecuteScriptButtonPressed(script: widget.script));
                  }))
        ]));
  }
}
