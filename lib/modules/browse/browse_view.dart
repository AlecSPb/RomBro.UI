import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/models/rom_model.dart';
import 'package:rombro/widgets/empty_text_widget.dart';
import 'package:rombro/widgets/rom_list_tile.dart';
import 'browse.dart';

class BrowseViewState extends StatefulWidget {
  BrowseViewState({Key key}) : super(key: key);

  @override
  _BrowseView createState() => new _BrowseView();
}

class _BrowseView extends State<BrowseViewState> {
  String _romType;
  ScrollController _scrollController = new ScrollController();
  bool _canScroll = true;
  BrowseBloc _browseBloc;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _browseBloc = BrowseBloc();
    _browseBloc.dispatch(FetchAvailableConsoles());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!_canScroll) return;
        _browseBloc
            .dispatch(StartBrowsing(type: _romType, deletePrevious: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(RomModel rom) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: RomListTile(
              rom: rom,
            ),
          ),
        );

    final makeBody = Container(
        decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: BlocBuilder(
            bloc: _browseBloc,
            builder: (BuildContext context, BrowseState state) {
              print("state.. $state");
              if (state is InitialView)
                return EmptyTextWidget();
              else if (state is AvailableConsolesFetched)
                return EmptyTextWidget();
              else if (state is BrowseFetching) {
                return StreamBuilder<List<RomModel>>(
                    stream: _browseBloc.browsedRomsStream,
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) return EmptyTextWidget();
                      if (snapshot.hasData) {
                        return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount:
                                snapshot.hasData ? snapshot.data.length : 0,
                            itemBuilder: (BuildContext context, int index) {
                              RomModel item = snapshot.data[index];
                              return makeCard(item);
                            });
                      }
                    });
              }
            }));

    Widget buildBody() {
      return makeBody;
    }

    Widget _romFilterDropdown() {
      return Card(
          child: Column(children: <Widget>[
        new ListTile(
            leading: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            title: DropdownButtonHideUnderline(
                child: BlocBuilder(
                    bloc: _browseBloc,
                    builder: (BuildContext context, BrowseState state) {
                      print("state dropdown: $state");                    
                        return StreamBuilder<List<String>>(
                            stream: _browseBloc.availableConsolesStream,
                            initialData: [],
                            builder:
                                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.hasError) print(snapshot.error);
                              if (snapshot.hasData) {
                                return DropdownButton<String>(
                                    onChanged: (String type) {
                                      setState(() {
                                        _romType = type;
                                        _canScroll = true;
                                      });
                                      _browseBloc
                                          .dispatch(StartBrowsing(type: type));
                                    },
                                    hint: new Text(
                                        "Select a console to browse for...",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic)),
                                    value: _romType,
                                    items: snapshot.data.map((type) {
                                      return DropdownMenuItem(
                                          value: type,
                                          child: new Text(type.toString()));
                                    }).toList());
                              } else {
                                return DropdownMenuItem(
                                    child: new Text(
                                        "Select the console type here...",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey)));
                              }
                            });                      
                    })))
      ]));
    }

    return BlocProvider<BrowseBloc>(
        bloc: _browseBloc,
        child: Column(
          children: <Widget>[
            _romFilterDropdown(),
            new Divider(color: Colors.white),
            Expanded(
                child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[Expanded(child: buildBody())]))
          ],
        ));
  }
}
