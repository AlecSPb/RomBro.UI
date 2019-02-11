import 'package:equatable/equatable.dart';
import 'package:rombro/models/rom_model.dart';

abstract class BrowseState extends Equatable {
  BrowseState([List props = const []]) : super(props);
}

class InitialView extends BrowseState {
  @override
  String toString() => "InitialView";
}

class AvailableConsolesFetched extends BrowseState {
  final List<String> availableConsoles;

  AvailableConsolesFetched(this.availableConsoles) : super([availableConsoles]);
  @override
  String toString() => 'AvailableConsolesFetched';
}

class BrowseFetching extends BrowseState {
  @override
  String toString() => 'BrowseFetching';
}