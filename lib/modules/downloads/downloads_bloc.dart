import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rombro/events/events.dart';
import 'package:rombro/hubs/rom_hub.dart';
import 'package:rombro/models/rom_download_model.dart';
import 'package:rombro/modules/downloads/downloads_event.dart';
import 'package:rombro/modules/downloads/downloads_state.dart';
import 'package:rxdart/rxdart.dart';

class DownloadsBloc extends Bloc<DownloadEvent, DownloadsState> {
  final RomHub hub = RomHub();
  final List<RomDownloadModel> downloads = List<RomDownloadModel>();
  final _downloadsSubject = BehaviorSubject<List<RomDownloadModel>>();
  Stream<List<RomDownloadModel>> get romDownloads => _downloadsSubject.stream;
  final _eventHandler = EventHandler();
  StreamSubscription _downloadCreatedEvent;
  StreamSubscription _downloadExtractedEvent;

  DownloadsBloc() {
    _downloadCreatedEvent =
        _eventHandler.eventBus.on<DownloadCreatedEvent>().listen((event) {
      _handleDownloadCreated(event);
    });

    _downloadExtractedEvent =
        _eventHandler.eventBus.on<DownloadExtractedEvent>().listen((event) {
      _handleDownloadExtracted(event);
    });
  }

  void _handleDownloadCreated(DownloadCreatedEvent downloadCreatedEvent) {
    var found = downloads.firstWhere(
        (match) => match.id == downloadCreatedEvent.download.id,
        orElse: () => RomDownloadModel());
    if (found.id == null) {
      downloads.add(downloadCreatedEvent.download);
      _downloadsSubject.add(downloads);
    }
  }

  void _handleDownloadExtracted(DownloadExtractedEvent event) {
    print("download extracted: ${event.id}");
    var download = downloads.firstWhere((match) => match.id == event.id);
    download.isExtracted = true;
    _downloadsSubject.add(downloads);
  }

  @override
  void dispose() {
    _downloadCreatedEvent.cancel();
    _downloadExtractedEvent.cancel();
    _downloadsSubject.close();
    super.dispose();
  }

  @override
  DownloadsState get initialState => InitialView();

  @override
  Stream<DownloadsState> mapEventToState(
    DownloadsState currentState,
    DownloadEvent event,
  ) async* {
    print("download event incoming: $event");
    if (event is DeleteDownloadButtonPressed) {
      try {
        hub.deleteDownloadedRom(event.rom.id).then((result) {
          if (result) {
            this.dispatch(DownloadDeleted(rom: event.rom));
          }
        });
      } catch (error) {}
    } else if (event is FetchDownloads) {
      try {
        yield FetchingDownloads();
        await hub.getAllDownloadedRoms().then((results) {
          for (var download in results) {
            var downloadResult = RomDownloadModel.fromJson(download);
            var found = downloads.firstWhere(
                (match) => match.id == downloadResult.id,
                orElse: () => RomDownloadModel());

            if (found.id == null) {
              downloads.add(downloadResult);
              _downloadsSubject.add(downloads);
            }
          }
        });
        yield DownloadsUpdated(downloads);
      } catch (error) {}
    } else if (event is DownloadDeleted) {
      downloads.removeWhere((match) => match.id == event.rom.id);
      yield DownloadDeletedSuccessfully(event.rom.name);
    } else if (event is UpdateDownloads) {
      yield DownloadsUpdated(downloads);
    }
  }
}
