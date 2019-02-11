import 'dart:typed_data';

abstract class RomBaseModel {
  final String id;
  final String name;
  final String type;
  final String url;
  final Uint8List bytes;

  RomBaseModel(this.id, this.name, this.type, this.url, this.bytes);
}
