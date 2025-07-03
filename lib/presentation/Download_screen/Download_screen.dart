import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class DownloadBody extends StatefulWidget {
  const DownloadBody({super.key});

  @override
  State<DownloadBody> createState() => _DownloadBodyState();
}

class _DownloadBodyState extends State<DownloadBody> {
  List<FileSystemEntity> downloadedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/downloads');

    if (await downloadDir.exists()) {
      setState(() {
        downloadedFiles = downloadDir.listSync()
          ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      });
    } else {
      await downloadDir.create(recursive: true);
      setState(() => downloadedFiles = []);
    }
  }

  void _deleteFile(FileSystemEntity file) async {
    await file.delete();
    _loadDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: downloadedFiles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/app_specific/download.jpg",
              width: 550.w,
              height: 550.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: downloadedFiles.length,
        itemBuilder: (context, index) {
          final file = downloadedFiles[index];
          final fileName = file.path.split('/').last;

          return ListTile(
            leading: Icon(Icons.picture_as_pdf, size: 35.sp, color: Colors.blue),
            title: Text(fileName, style: TextStyle(fontSize: 16.sp)),
            subtitle: Text('${(file.statSync().size / 1024).toStringAsFixed(2)} KB'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteFile(file),
            ),
            onTap: () {
              // Handle file open
            },
          );
        },
      ),
    );
  }
}
