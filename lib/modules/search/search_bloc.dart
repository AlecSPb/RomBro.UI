import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rombro/hubs/rom_hub.dart';
import 'package:rombro/models/rom_model.dart';
import 'search.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RomHub _hub = RomHub();
  final List<RomModel> searchedRoms = List<RomModel>();
  BehaviorSubject<List<RomModel>> _searchRomsSubject = BehaviorSubject<List<RomModel>>();
  Stream<List<RomModel>> get searchedRomsStream => _searchRomsSubject.stream;

  @override
  SearchState get initialState => InitialView();

  @override
  Stream<SearchState> mapEventToState(
    SearchState currentState,
    SearchEvent event,
  ) async* {
    print("browse current state: $currentState");
    print("browse event incoming: $event");
    if (event is StartSearching) {
      searchedRoms.clear();
      yield Searching();
      var resultStream = _hub.streamSearchRom(event.name);
      resultStream
          .forEach((item) {
            var model = RomModel.fromJson(item);
            searchedRoms.add(model);
            _searchRomsSubject.add(searchedRoms);
          })
          .catchError((error) => _searchRomsSubject.addError(error))
          .whenComplete(() {});
    } else if (event is DownloadRom) {
      try {
        await _hub.downloadRom(event.rom.id);
      } catch (error) {}
    }
  }

  @override
  void dispose() {
    _searchRomsSubject.close();
    searchedRoms.clear();
    super.dispose();
  }
}
