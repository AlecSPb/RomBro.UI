import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rombro/events/events.dart';
import 'package:rombro/hubs/rom_hub.dart';
import 'package:rombro/modules/search/search.dart' as _searchView;
import 'package:rombro/modules/downloads/downloads.dart' as _downloadView;
import 'package:rombro/modules/browse/browse.dart' as _browseView;
import './screens/about.dart' as _aboutPage;
import 'package:rombro/modules/scripts/scripts.dart' as _scriptsView;
import 'package:rombro/modules/settings/settings.dart' as _settingsVeiw;

void main() {
  runApp(new MaterialApp(
    title: 'RomBro',
    theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0)),
    home: new Scaffold(body: new Tabs(), resizeToAvoidBottomPadding: false),
    onGenerateRoute: (RouteSettings settings) {
      switch (settings.name) {
        case '/about':
          return new FromRightToLeft(
            builder: (_) => new _aboutPage.About(),
            settings: settings,
          );
        case '/scripts':
          return new FromRightToLeft(
            builder: (_) => new _scriptsView.ScriptsViewData(),
            settings: settings,
          );
        case '/settings':
          return new FromRightToLeft(
            builder: (_) => new _settingsVeiw.SettingsViewData(),
            settings: settings,
          );
      }
    },
  ));
}

class FromRightToLeft<T> extends MaterialPageRoute<T> {
  FromRightToLeft({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    return new SlideTransition(
      child: new Container(
        decoration: new BoxDecoration(boxShadow: [
          new BoxShadow(
            color: Colors.black26,
            blurRadius: 25.0,
          )
        ]),
        child: child,
      ),
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(new CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);
}

class Tabs extends StatefulWidget {
  @override
  TabsState createState() => new TabsState();
}

class TabsState extends State<Tabs> {
  PageController _tabController;
  final _eventHandler = new EventHandler();
  final RomHub _hub = RomHub();
  var _appTitle;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    this._appTitle = TabItems[0].title;
    _tabController = new PageController();
    _eventHandler.eventBus.on<ServiceDisconnectedEvent>().listen((event) {
      _showDialog();
    });
  }

  void _showDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Disconnected from the service..."),
            content: new Text("Please check if the service is still running"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Connect"),
                  onPressed: () {
                    _hub.setupConnection().then((result) {
                      if (result) Navigator.of(context).pop();
                    });
                  }),
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        title: new Text(_appTitle,
            style: new TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS
                  ? 17.0
                  : 20.0,
            )),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new PageView(
        controller: _tabController,
        onPageChanged: onTabChanged,
        children: <Widget>[
          new _browseView.BrowseViewState(),
          new _searchView.SearchViewState(),
          new _downloadView.DownloadsViewState()
        ],
      ),
      bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
          ? new CupertinoTabBar(
              activeColor: Color.fromRGBO(58, 66, 86, 1.0),
              currentIndex: _tabIndex,
              onTap: onTap,
              items: TabItems.map((TabItem) {
                return new BottomNavigationBarItem(
                  icon: new Icon(TabItem.icon),
                );
              }).toList(),
            )
          : new Theme(
              data: Theme.of(context).copyWith(
                  canvasColor: Color.fromRGBO(58, 66, 86, 1.0),
                  primaryColor: Colors.lightBlueAccent,
                  textTheme: Theme.of(context)
                      .textTheme
                      .copyWith(caption: new TextStyle(color: Colors.white))),
              child: BottomNavigationBar(
                currentIndex: _tabIndex,
                onTap: onTap,
                items: TabItems.map((TabItem) {
                  return new BottomNavigationBarItem(
                    title: new Text(""),
                    icon: new Icon(TabItem.icon),
                  );
                }).toList(),
              )),
      drawer: new Drawer(
          child: Container(
              decoration: new BoxDecoration(
                color: Color.fromRGBO(58, 66, 86, 1.0),
              ),
              child: new ListView(
                children: <Widget>[
                  Container(
                    height: 120.0,
                    child: new DrawerHeader(
                      padding: new EdgeInsets.all(0.0),
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(58, 66, 86, 1.0),
                      ),
                      child: new Center(
                          child: Image.asset("assets/logo.png",
                              scale: 11, fit: BoxFit.none)),
                    ),
                  ),
                  new ListTile(
                      leading:
                          new Icon(Icons.send, size: 24, color: Colors.white),
                      title: new Text(
                        'Scripts',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/scripts');
                      }),
                  new ListTile(
                      leading: new Icon(Icons.settings,
                          size: 24, color: Colors.white),
                      title: new Text(
                        'Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/settings');
                      }),
                ],
              ))));

  void onTap(int tab) {
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState(() {
      this._tabIndex = tab;
    });

    switch (tab) {
      case 0:
        this._appTitle = TabItems[0].title;
        break;

      case 1:
        this._appTitle = TabItems[1].title;
        break;

      case 2:
        this._appTitle = TabItems[2].title;
        break;
    }
  }
}

class TabItem {
  const TabItem({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Browse', icon: Icons.folder),
  const TabItem(title: 'Search', icon: Icons.search),
  const TabItem(title: 'Downloads', icon: Icons.file_download)
];
