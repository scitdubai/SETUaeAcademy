import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:set_academy/Utils/Color.dart';
import 'package:set_academy/screen/video/providerfordonaload.dart';

class FileDownloader extends StatefulWidget {
  final String downloadurl;
  final String name;

  const FileDownloader({super.key, required this.downloadurl, required this.name});

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  late String fileUrl;

  @override
  void initState() {
    super.initState();
    fileUrl = widget.downloadurl;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DownloadProvider>(context);
    final fileState = provider.getFileDownloadState(widget.name) ?? FileDownloadState();

    return Column(
      children: [
        (fileState.totalBytes != 0 && fileState.receivedBytes < fileState.totalBytes)
            ? Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 10),
                  Text(
                    "${(fileState.receivedBytes / fileState.totalBytes * 100).toStringAsFixed(0)}%",
                    style: TextStyle(color: Color(Colorbutton)),
                  ),
                ],
              )
            : (!fileState.downloadInProgress && fileState.totalBytes == 0)
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(Colorbutton)),
                    ),
                    onPressed: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                      ].request();

                      if (statuses[Permission.storage]!.isGranted) {
                        var dir = await DownloadsPathProvider.downloadsDirectory;
                        if (dir != null) {
                          String saveName = widget.name;
                          String savePath = '${dir.path}/$saveName.pdf';

                          await Dio().download(
                            fileUrl,
                            savePath,
                            onReceiveProgress: (received, total) {
                              if (total != -1) {
                                provider.updateProgress(widget.name, received, total);
                              }
                            },
                          );

                          provider.completeDownload(widget.name); // إنهاء التحميل
                          print("File is saved to download folder.");
                        }
                      } else {
                        print("No permission to read and write.");
                      }
                    },
                    child: Text(
                      "بدء التحميل",
                      style: TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  )
                : Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                      child: Text(
                        "افتح الملف",
                        style: TextStyle(color: Colors.white, fontSize: 9),
                      ),
                      onPressed: () async {
                        var dir = await DownloadsPathProvider.downloadsDirectory;
                        OpenFilex.open('${dir!.path}/${widget.name}.pdf');
                      },
                    ),
                  ),
      ],
    );
  }
}
