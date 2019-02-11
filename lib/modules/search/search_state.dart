import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class InitialView extends SearchState {
  @override
  String toString() => "InitialView";
}

class Searching extends SearchState {
  @override
  String toString() => "Searching";
}
