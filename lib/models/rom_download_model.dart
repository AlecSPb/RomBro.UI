import 'dart:typed_data';
import 'dart:convert';
import 'package:rombro/models/rom_base_model.dart';

class RomDownloadModel extends RomBaseModel {
  bool isExtracted = false;
  bool isDownloaded = false;
  String get state {
    if (isExtracted == null && isDownloaded == null) return "Starting...";
    if (!this.isDownloaded && !this.isExtracted) return "Downloading";
    if (this.isDownloaded && !isExtracted) return "Extracting";
    if (this.isExtracted) return "Extracted";

    return "Starting...";
  }

  RomDownloadModel(
      {String id,
      String name,
      String type,
      String url,
      Uint8List bytes,
      this.isDownloaded,
      this.isExtracted})
      : super(id, name, type, url, bytes);

  factory RomDownloadModel.fromJson(Map<String, dynamic> json) {
    Uint8List bytes = base64.decode(json["imageData"]);
    return RomDownloadModel(
        id: json["id"],
        name: json['name'],
        type: json["type"],
        url: json["url"],
        isExtracted: json["isExtracted"],
        isDownloaded: json["isDownloaded"],
        bytes: bytes);
  }
}

class RomDownloadModelList {
  final List<RomDownloadModel> allDownloads;

  RomDownloadModelList({this.allDownloads});

  factory RomDownloadModelList.fromJson(List<dynamic> json) {
    List<RomDownloadModel> roms = new List<RomDownloadModel>();
    roms = json.map((i) => RomDownloadModel.fromJson(i)).toList();
    return new RomDownloadModelList(allDownloads: roms);
  }
}
