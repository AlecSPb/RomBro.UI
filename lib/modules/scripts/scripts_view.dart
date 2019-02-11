import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/widgets/empty_text_widget.dart';
import 'scripts.dart';

class ScriptsViewData extends StatefulWidget {
  ScriptsViewData({Key key}) : super(key: key);

  @override
  _ScriptsViewState createState() => new _ScriptsViewState();
}

class _ScriptsViewState extends State<ScriptsViewData> {
  ScriptsBloc _scriptsBloc;

  _ScriptsViewState() {
    _scriptsBloc = ScriptsBloc();
    _scriptsBloc.dispatch(FetchScripts());
  }
  @override
  Widget build(BuildContext context) {
    Card makeCard(ScriptModel command) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: ScriptListTile(
              script: command,
            ),
          ),
        );
    final makeBody = Container(
        decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: BlocBuilder(
            bloc: _scriptsBloc,
            builder: (BuildContext context, ScriptsState state) {
              print("state scripts: $state");
              if (state is InitialView && _scriptsBloc.scripts.length <= 0)
                return EmptyTextWidget();

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _scriptsBloc.scripts.length,
                  itemBuilder: (BuildContext context, int index) {
                    ScriptModel item = _scriptsBloc.scripts[index];
                    return makeCard(item);
                  });
            }));

    Widget buildBody() {
      return makeBody;
    }

    return new Scaffold(
        body: BlocProvider<ScriptsBloc>(
            bloc: _scriptsBloc,
            child: Column(children: <Widget>[
              Expanded(
                  child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[Expanded(child: buildBody())]))
            ])),
        appBar: new AppBar(
          title: new Text(
            'Scripts',
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
  //Content of tabs
}
