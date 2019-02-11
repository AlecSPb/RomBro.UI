import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rombro/modules/scripts/scripts.dart';

abstract class ScriptsEvent extends Equatable {
  ScriptsEvent([List props = const []]) : super(props);
}

class ExecuteScriptButtonPressed extends ScriptsEvent {
  final ScriptModel script;

  ExecuteScriptButtonPressed({
    @required this.script,
  }) : super([script]);

  @override
  String toString() => 'ExecuteScriptButtonPressed { script id: ${script.identifier}}';
}

class FetchScripts extends ScriptsEvent {
  @override
  String toString() => 'FetchScripts started';
}



