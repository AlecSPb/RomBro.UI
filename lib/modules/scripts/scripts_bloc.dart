import 'package:rombro/hubs/rom_hub.dart';
import 'package:rombro/modules/scripts/scripts.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

class ScriptsBloc extends Bloc<ScriptsEvent, ScriptsState> {
  final RomHub hub = RomHub();
  final List<ScriptModel> scripts = List<ScriptModel>();

  @override
  ScriptsState get initialState => InitialView();

  @override
  Stream<ScriptsState> mapEventToState(
    ScriptsState currentState,
    ScriptsEvent event,
  ) async* {
    print("script event incoming: $event");
    if (event is ExecuteScriptButtonPressed) {
      hub.executeScript(event.script.identifier);
    } else if (event is FetchScripts) {
      yield FetchingScripts();
      var allScripts = await hub.getAvailableScripts();
      scripts.addAll(allScripts);
      yield ScriptsFetched(scripts);
    }
  }
}
