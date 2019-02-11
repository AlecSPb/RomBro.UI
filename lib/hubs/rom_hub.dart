import 'package:rombro/events/event_handler.dart';
import 'package:rombro/events/events.dart';
import 'package:rombro/helpers/config.dart';
import 'package:rombro/models/rom_download_model.dart';
import 'package:rombro/modules/scripts/scripts.dart';
import 'package:signalr_client/signalr_client.dart';
import 'dart:async';

class RomHub {
  ConfigHelper helper = ConfigHelper();
  HubConnection hubConnectionBuild;
  final _eventHandler = EventHandler();
  static final RomHub _singleton = new RomHub._internal();

  factory RomHub() {
    return _singleton;
  }

  RomHub._internal() {
    setupConnection();
  }

  Future<bool> initialize() async {
    await helper.initialize();
    print("endpoint hub: ${helper.endpoint}");
    hubConnectionBuild =
        HubConnectionBuilder().withUrl(helper.endpoint).build();
    hubConnectionBuild.serverTimeoutInMilliseconds = 30000;
    hubConnectionBuild.onclose((error) {
      print("closed...");
      _eventHandler.fireServiceDisconnected();
    });
    _registerHubListeners();
    return true;
  }

  Future<bool> setupConnection() async {
    var result = await initialize();
    var completer = new Completer<bool>();
    if (result) {
      hubConnectionBuild.start().then((value) {
        _eventHandler.fireServiceConnected();
        completer.complete(true);
      }).catchError((error) {
        completer.complete(false);
      });

      return completer.future;
    }

    return false;
  }

  void _registerHubListeners() {
    hubConnectionBuild.on(
        'DownloadCreated', (download) => _handleDownloadCreated(download));

    hubConnectionBuild.on(
        'DeletedRom', (download) => _handleRomDeleted(download));

    hubConnectionBuild.on(
        'DownloadExtracted', (download) => _handleDownloadExtracted(download));
  }

  void _handleDownloadExtracted(List<dynamic> update) {
    String id = update[0];
    print("extracted: $id");
    var event = new DownloadExtractedEvent(id);
    _eventHandler.eventBus.fire(event);
  }

  void _handleRomDeleted(List<dynamic> download) {
    var removed = download[0];
    _eventHandler.fireDownloadDeleted(removed);
  }

  void _handleDownloadCreated(List<dynamic> downloads) {
    var download = RomDownloadModel.fromJson(downloads[0]);
    _eventHandler.fireDownloadCreated(download);
  }

  void executeScript(String identifier) {
    _checkConnectionState();
    hubConnectionBuild.invoke("ExecuteScript", args: [identifier]);
  }

  void _checkConnectionState() {
    if (hubConnectionBuild.state != HubConnectionState.Connected)
      throw Exception("Connect first");
  }

  Future<List<dynamic>> getAllDownloadedRoms() async {
    _checkConnectionState();
    return await hubConnectionBuild.invoke("GetDownloadedRoms");
  }

  Future<List<ScriptModel>> getAvailableScripts() async {
    _checkConnectionState();
    var list = new List<ScriptModel>();
    await hubConnectionBuild.invoke("GetScripts").then((commands) {
      for (var command in commands) {
        var commandResult = ScriptModel.fromJson(command);
        print("result: ${commandResult.name}");
        list.add(commandResult);
      }
    });

    return list;
  }

  Future<List<String>> getAvailableConsoles() async {
    _checkConnectionState();
    List<dynamic> result =
        await hubConnectionBuild.invoke("GetAvailableConsoles");
    var data = result.cast<String>().toList();
    return data;
  }

  Future<String> downloadRom(String id) async {
    _checkConnectionState();
    return await hubConnectionBuild.invoke("DownloadRom", args: [id]);
  }

  Future<bool> deleteDownloadedRom(String id) async {
    _checkConnectionState();
    var result =
        await hubConnectionBuild.invoke("DeleteDownloadedRom", args: [id]);
    return result as bool;
  }

  Stream<Object> streamBrowseRoms(String type, int page) {
    _checkConnectionState();
    page++;
    return hubConnectionBuild.stream("StreamBrowseRoms", [type, page]);
  }

  Stream<Object> streamSearchRom(String romName) {
    _checkConnectionState();
    return hubConnectionBuild.stream("StreamSearchRom", [romName]);
  }

  Future<int> getBrowsePageCount(String consoleType) async {
    _checkConnectionState();
    return await hubConnectionBuild
        .invoke("GetBrowsePageCount", args: [consoleType]);
  }
}
