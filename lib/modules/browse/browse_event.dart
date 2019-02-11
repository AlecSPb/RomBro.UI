import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rombro/models/rom_model.dart';

abstract class BrowseEvent extends Equatable {
  BrowseEvent([List props = const []]) : super(props);
}

class StartBrowsing extends BrowseEvent {
  final String type;
  final bool deletePrevious;

  StartBrowsing({
    @required this.type,
    this.deletePrevious = true,
  }) : super([type]);

  @override
  String toString() => 'StartBrowsing { type $type }';
}

class FetchAvailableConsoles extends BrowseEvent {
  @override
  String toString() => 'FetchAvailableConsoles started';
}

class DownloadRom extends BrowseEvent {
  final RomModel rom;

  DownloadRom(this.rom) : super([rom]);

  @override
  String toString() => 'DownloadRom started';
}
