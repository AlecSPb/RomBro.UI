import 'package:rombro/models/rom_download_model.dart';

class DownloadCreatedEvent {
  RomDownloadModel download;
  DownloadCreatedEvent(this.download);
}