import 'package:flutter/material.dart';
import 'package:rombro/models/rom_download_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/modules/downloads/downloads.dart';

class RomDownloadListTile extends StatefulWidget {
  final RomDownloadModel rom;
  const RomDownloadListTile({Key key, this.rom}) : super(key: key);
  @override
  RomDownloadListTileState createState() {
    return new RomDownloadListTileState();
  }
}

class RomDownloadListTileState extends State<RomDownloadListTile> {
  @override
  Widget build(BuildContext context) {
    final downloadsBloc = BlocProvider.of<DownloadsBloc>(context);

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
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 1, top: 5),
                child: Text("State: ${widget.rom.state}",
                    style: TextStyle(color: Colors.white))),
          )
        ],
      ),
      trailing: new Column(children: <Widget>[
        new Container(
            child: new IconButton(
                icon:
                    Icon(Icons.delete_forever, color: Colors.white, size: 30.0),
                onPressed: () {
                  downloadsBloc
                      .dispatch(DeleteDownloadButtonPressed(rom: widget.rom));
                }))
      ]),
      onTap: () {},
    );
  }
}
