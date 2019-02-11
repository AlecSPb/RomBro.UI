import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/models/rom_model.dart';
import 'package:rombro/modules/browse/browse.dart';

class RomListTile extends StatefulWidget {
  final RomModel rom;
  const RomListTile({Key key, this.rom}) : super(key: key);
  @override
  RomListTileState createState() {
    return new RomListTileState();
  }
}

class RomListTileState extends State<RomListTile> {
  @override
  Widget build(BuildContext context) {
    final browseBloc = BlocProvider.of<BrowseBloc>(context);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      leading: Container(
          padding: EdgeInsets.only(right: 20),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 2.0, color: Colors.grey))),
          child: Image.memory(
            widget.rom.bytes,
            scale: 1.7,
          )),
      title: Text(
        widget.rom.name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 1, top: 5),
                child: Text("Console: ${widget.rom.type}",
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing: new Column(children: <Widget>[
        new Container(
            child: new IconButton(
                icon:
                    Icon(Icons.file_download, color: Colors.white, size: 30.0),
                onPressed: () {
                  browseBloc.dispatch(DownloadRom(widget.rom));
                }))
      ]),
      onTap: () {},
    );
  }
}
