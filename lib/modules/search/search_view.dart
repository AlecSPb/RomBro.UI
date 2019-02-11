import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rombro/models/rom_model.dart';
import 'package:rombro/widgets/empty_text_widget.dart';
import 'search.dart';
class SearchViewState extends StatefulWidget {
  const SearchViewState({Key key}) : super(key: key);

  @override
  _SearchView createState() => new _SearchView();
}

class _SearchView extends State<SearchViewState> {
  SearchBloc _searchBloc;
  @override
  void initState() {
    super.initState();
    _searchBloc = new SearchBloc();    
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(RomModel rom) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          leading: Container(
              decoration: new BoxDecoration(
                  border: new Border(
                      right:
                          new BorderSide(width: 1.0, color: Colors.white24))),
              child: Image.memory(
                rom.bytes,
                scale: 1.7,
              )),
          title: Text(
            rom.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 1, top: 5),
                    child: Text("Console: ${rom.type}",
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          trailing: new Column(children: <Widget>[
            new Container(
                child: new IconButton(
                    icon: Icon(Icons.file_download,
                        color: Colors.white, size: 30.0),
                    onPressed: () {
                      _searchBloc.dispatch(DownloadRom(rom));
                    }))
          ]),
          onTap: () {
            print("e");
          },
        );

    Card makeCard(RomModel lesson) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(lesson),
          ),
        );

    final makeBody = Container(
        decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
        child: BlocBuilder(
            bloc: _searchBloc,
            builder: (BuildContext context, SearchState state) {
              print("search view state.. $state");
              if (state is InitialView)
                return EmptyTextWidget();
              else if (state is Searching) {
                return StreamBuilder<List<RomModel>>(
                    stream: _searchBloc.searchedRomsStream,
                    initialData: [],
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError) return EmptyTextWidget();
                      if (snapshot.hasData) {
                        return ListView.builder(
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

    Widget _searchBar() {
      return new Card(
          child: new ListTile(
              leading: const Icon(Icons.search, color: Colors.grey),
              title: TextField(
                  onSubmitted: ((name) {
                    if (name == "") return;
                    _searchBloc.dispatch(StartSearching(name: name));
                  }),
                  decoration: const InputDecoration(
                      hintText: "Search a ROM by its name...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic)))));
    }

    return Column(children: <Widget>[
      _searchBar(),
      new Divider(color: Colors.white),
      Expanded(
          child: Flex(
              direction: Axis.vertical,
              children: <Widget>[Expanded(child: buildBody())]))
    ]);
  }
}