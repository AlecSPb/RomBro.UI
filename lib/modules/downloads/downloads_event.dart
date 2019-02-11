import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:rombro/models/rom_download_model.dart';

abstract class DownloadEvent extends Equatable {
  DownloadEvent([List props = const []]) : super(props);
}

class DeleteDownloadButtonPressed extends DownloadEvent {
  final RomDownloadModel rom;

  DeleteDownloadButtonPressed({
    @required this.rom,
  }) : super([rom]);

  @override
  String toString() => 'DeleteDownloadButtonPressed { rom id: ${rom.id}}';
}

class DownloadDeleted extends DownloadEvent {
  final RomDownloadModel rom;

  DownloadDeleted({
    @required this.rom,
  }) : super([rom]);
  @override
  String toString() => 'DownloadDeleted';
}

class FetchDownloads extends DownloadEvent {
  @override
  String toString() => 'FetchDownloads started';
}

class UpdateDownloads extends DownloadEvent {
  @override
  String toString() => 'UpdateDownloads started';
}

