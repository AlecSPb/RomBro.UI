import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rombro/hubs/rom_hub.dart';
import 'package:rombro/models/rom_model.dart';
import 'package:rombro/modules/browse/browse.dart';
import 'package:rxdart/rxdart.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RomHub _hub = RomHub();
  final List<RomModel> browsedRoms = List<RomModel>();
  final List<String> availableConsoles = List<String>();
  final _browseRomsSubject = BehaviorSubject<List<RomModel>>();
  final _availableConsolesSubject = BehaviorSubject<List<String>>();
  Stream<List<RomModel>> get browsedRomsStream => _browseRomsSubject.stream;
  Stream<List<String>> get availableConsolesStream =>
      _availableConsolesSubject.stream;
  int _browsePageCount;
  int _currentPageCount;
  bool _isFetching = false;

  @override
  BrowseState get initialState => InitialView();

  @override
  Stream<BrowseState> mapEventToState(
    BrowseState currentState,
    BrowseEvent event,
  ) async* {
    print("browse current state: $currentState");
    print("browse event incoming: $event");
    if (event is FetchAvailableConsoles) {
      await _hub.getAvailableConsoles().then((consoles) {
        for (var console in consoles) {
          availableConsoles.add(console);
          _availableConsolesSubject.add(availableConsoles);
        }
      });
    } else if (event is StartBrowsing) {
      if (_isFetching) return;
      try {        
        if (event.deletePrevious) {
          // a new console type has been selected
          browsedRoms.clear();
          _browseRomsSubject.add(browsedRoms);
          _currentPageCount = 0;
        }

        _browsePageCount = await _hub.getBrowsePageCount(event.type);
        if (_browsePageCount <= _currentPageCount)
          return; // we reached the last page

        yield BrowseFetching();
        _isFetching = true;
        var resultStream = _hub.streamBrowseRoms(event.type, _currentPageCount);
        resultStream
            .forEach((item) {
              var model = RomModel.fromJson(item);
              browsedRoms.add(model);
              _browseRomsSubject.add(browsedRoms);
            })
            .catchError((error) => _browseRomsSubject.addError(error))
            .whenComplete(() {
              _currentPageCount++;
              _isFetching = false;
            });
      } catch (error) {} finally {        
      }
    } else if (event is DownloadRom) {
      try {
        await _hub.downloadRom(event.rom.id);
      } catch (error) {}
    }
  }

  @override
  void dispose() {
    _browseRomsSubject.close();
    browsedRoms.clear();
    _availableConsolesSubject.close();
    availableConsoles.clear();
    super.dispose();
  }
}
