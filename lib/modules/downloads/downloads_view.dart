import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/models/rom_download_model.dart';
import 'package:rombro/modules/downloads/downloads.dart';
import 'package:rombro/widgets/empty_text_widget.dart';
import 'package:rombro/widgets/mario_progress.dart';
import 'package:rombro/widgets/rom_download_list_tile.dart';

class DownloadsViewState extends StatefulWidget {
  DownloadsViewState({Key key}) : super(key: key);

  @override
  _DownloadsView createState() => _DownloadsView();
}

class _DownloadsView extends State<DownloadsViewState> {
  DownloadsBloc _downloadsBloc;

  @override
  void initState() {
    _downloadsBloc = DownloadsBloc();
    _downloadsBloc.dispatch(FetchDownloads());
    super.initState();
  }

  @override
  void dispose() {
    _downloadsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(RomDownloadModel rom) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: RomDownloadListTile(
              rom: rom,
            ),
          ),
        );

    final makeBody = Container(
      decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: BlocBuilder(
          bloc: _downloadsBloc,
          builder: (BuildContext context, DownloadsState state) {
            print("state: $state");
            if (state is InitialView)
              return EmptyTextWidget();
            else if (state is DownloadDeletedSuccessfully) {
              print("deleted ${state.name}");
            } else if (state is FetchingDownloads)
              return MarioLoadingWidget();
            else if (state is DownloadsUpdated &&
                _downloadsBloc.downloads.length <= 0) return EmptyTextWidget();

            return StreamBuilder<List<RomDownloadModel>>(
                stream: _downloadsBloc.romDownloads,
                initialData: [],
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.hasData ? snapshot.data.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          RomDownloadModel item = snapshot.data[index];
                          return Dismissible(
                              key: Key(item.id),
                              onDismissed: (direction) {
                                _downloadsBloc.dispatch(
                                    DeleteDownloadButtonPressed(rom: item));
                              },
                              child: makeCard(item));
                        });
                  }
                });
          }),
    );

    Widget buildBody() {
      return makeBody.build(context);
    }

    return BlocProvider<DownloadsBloc>(
        bloc: _downloadsBloc,
        child: Column(children: <Widget>[
          Expanded(
              child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[Expanded(child: buildBody())]))
        ]));
  }
}