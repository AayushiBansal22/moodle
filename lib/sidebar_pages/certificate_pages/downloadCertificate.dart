import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:moodle/checkPermission.dart';
import 'package:moodle/getPath.dart';
import 'package:open_file/open_file.dart';

class DownloadCertificate extends StatefulWidget {
  String certificateUrl;
  String certificateName;
  DownloadCertificate({Key? key, required this.certificateUrl, required this.certificateName}) : super(key: key);

  @override
  State<DownloadCertificate> createState() => _DownloadCertificateState();
}

class _DownloadCertificateState extends State<DownloadCertificate> {
  bool downloading = false;
  bool fileExists = false;
  double progress = 0.0;
  late CancelToken cancelToken;
  String url = '';
  String fileName = '';
  late String filePath;
  var getPathFile = DirectoryPath();
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  void startDownloading() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      downloading = true;
      progress = 0;
    });

    try{
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            progress = receivedBytes / totalBytes;
          });
          cancelToken: cancelToken;
        },
        deleteOnError: true,
      ).then((_) {
        Navigator.pop(context);
        openFile();
      });
    } catch(e) {
      log('$e');
      setState(() {
        downloading = false;
      });
    }
  }

  openFile() {
    OpenFile.open(filePath);
    log("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    url = widget.certificateUrl;
    fileName = widget.certificateName;
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 20,),
          Text(
            "Downloading: $downloadingprogress%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}