import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rombro/models/rom_model.dart';

abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class StartSearching extends SearchEvent {
  final String name;

  StartSearching({
    @required this.name,
}) : super([name]);

  @override
  String toString() => 'StartSearching { name $name }';
}

class DownloadRom extends SearchEvent {
  final RomModel rom;

  DownloadRom(this.rom) : super([rom]);

  @override
  String toString() => 'DownloadRom { name: ${rom.name}"';
}
