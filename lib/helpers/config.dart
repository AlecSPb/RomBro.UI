import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ConfigHelper {
  static final ConfigHelper _singleton = new ConfigHelper._internal();
  String _endpoint;
  String get endpoint => _endpoint;
  set endpoint(String newEndpoint) {
    _endpoint = newEndpoint;
    _configFile.then((file) {
      var jsonSave = json.encode(newEndpoint);
      file.writeAsString(jsonSave);
    });
  }

  factory ConfigHelper() {
    return _singleton;
  }

  ConfigHelper._internal() {}

  Future<bool> initialize() async {
    var configFile = await _configFile;
    var configContent = await configFile.readAsString();
    _endpoint = json.decode(configContent);
    return true;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _configFile async {
    final path = await _localPath;
    final file = File("$path/config.json");
    var configFileExists = await file.exists();
    if (!configFileExists) {
      var createdFile = await file.create();
      var defaultService = json.encode("http://retropie:5555/RomHub");
      createdFile.writeAsString(defaultService);
      return createdFile;
    }
    return file;
  }
}
