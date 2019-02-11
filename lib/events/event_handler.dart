import 'package:event_bus/event_bus.dart';
import 'package:rombro/events/events.dart';
import 'package:rombro/models/rom_download_model.dart';

class EventHandler {
  final EventBus eventBus = new EventBus();

  static final EventHandler _singleton = new EventHandler._internal();

  factory EventHandler() {
    return _singleton;
  }

  EventHandler._internal();

  void fireDownloadCreated(RomDownloadModel download) {
    eventBus.fire(new DownloadCreatedEvent(download));
  }

  void fireDownloadDeleted(String id) {
    eventBus.fire(new DownloadDeletedEvent(id));
  }

  void fireServiceDisconnected() {
    eventBus.fire(new ServiceDisconnectedEvent());
  }

  void fireServiceConnected() {
    eventBus.fire(new ServiceConnectedEvent());
  }
    void fireDownloadExtractedEvent(String id) {
    eventBus.fire(new DownloadExtractedEvent(id));
  }
}
