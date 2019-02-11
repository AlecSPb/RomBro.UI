import 'package:equatable/equatable.dart';
import 'package:rombro/models/rom_download_model.dart';

abstract class DownloadsState extends Equatable {
  
  DownloadsState([List props = const []]) : super(props);
}

class InitialView extends DownloadsState {
  @override
  String toString() => "InitialView";
}

class FetchingDownloads extends DownloadsState {
  @override
  String toString() => 'FetchingDownloads';
}

class DownloadsUpdated extends DownloadsState {
  final List<RomDownloadModel> downloads;

  DownloadsUpdated(this.downloads) : super([downloads]);
  @override
  String toString() => 'DownloadsUpdated';
}

class DownloadDeletedSuccessfully extends DownloadsState {
  final String name;

  DownloadDeletedSuccessfully(this.name) : super([name]);
  @override
  String toString() => 'DownloadDeletedSuccessfully';
}