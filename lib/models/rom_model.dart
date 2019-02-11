import 'dart:typed_data';
import 'dart:convert';
import 'package:rombro/models/rom_base_model.dart';

class RomModel extends RomBaseModel {
  RomModel({String id, String name, String type, String url, Uint8List bytes})
      : super(id, name, type, url, bytes);

  factory RomModel.fromJson(Map<String, dynamic> json) {
    Uint8List bytes = base64.decode(json["imageData"]);
    return RomModel(
        id: json["id"],
        name: json['name'],
        type: json["type"],
        url: json["url"],
        bytes: bytes);
  }
}
