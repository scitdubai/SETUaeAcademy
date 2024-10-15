import 'package:flutter/material.dart';

class FileDownloadState {
  int receivedBytes = 0;
  int totalBytes = 0;
  bool downloadInProgress = false;

  FileDownloadState();
}

class DownloadProvider with ChangeNotifier {
  final Map<String, FileDownloadState> _fileStates = {};

  void updateProgress(String fileName, int received, int total) {
    if (!_fileStates.containsKey(fileName)) {
      _fileStates[fileName] = FileDownloadState();
    }

    _fileStates[fileName]!.receivedBytes = received;
    _fileStates[fileName]!.totalBytes = total;
    _fileStates[fileName]!.downloadInProgress = true;

    notifyListeners();
  }

  void completeDownload(String fileName) {
    if (_fileStates.containsKey(fileName)) {
      _fileStates[fileName]!.downloadInProgress = false;
      notifyListeners();
    }
  }

  FileDownloadState? getFileDownloadState(String fileName) {
    return _fileStates[fileName];
  }

  void resetFileState(String fileName) {
    if (_fileStates.containsKey(fileName)) {
      _fileStates.remove(fileName);
      notifyListeners();
    }
  }
}
