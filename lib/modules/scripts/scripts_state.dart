import 'package:equatable/equatable.dart';
import 'package:rombro/modules/scripts/script_model.dart';

abstract class ScriptsState extends Equatable {
  
  ScriptsState([List props = const []]) : super(props);
}

class InitialView extends ScriptsState {
  @override
  String toString() => "InitialView Scripts";
}

class FetchingScripts extends ScriptsState {
  @override
  String toString() => 'FetchingScripts';
}

class ScriptsFetched extends ScriptsState {
  final List<ScriptModel> scripts;

  ScriptsFetched(this.scripts) : super([scripts]);
  @override
  String toString() => 'ScriptsFetched';
}

class ExecuteScript extends ScriptsState {
  final String id;

  ExecuteScript(this.id) : super([id]);
  @override
  String toString() => 'ExecuteScript';
}