// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager_example/flutter_cache_manager_impl.dart';
import 'package:internal/list_item.dart';
import 'package:internal/theme/colors.dart';

class BodyWidget extends StatefulWidget {
  const BodyWidget({super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final FlutterCacheManagerImpl implementation = FlutterCacheManagerImpl();
  String? newUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache manager'.toUpperCase()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          implementation.setNewUrl(newUrl);
          implementation.downloadFile();
        },
        tooltip: 'Download',
        child: const Icon(
          Icons.cloud_download_outlined,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<Stream<FileResponse>?>(
            stream: implementation.fileStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Click on the float button to start downloading',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Your can write new url address here',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => newUrl = value,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "If you want to set a new url, you can write it in the text box and then"
                      "click on the float button or leave the box blank if you want to upload the default file",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                );
              }
              return StreamBuilder<FileResponse>(
                stream: snapshot.data as Stream<FileResponse>,
                builder: (BuildContext context, AsyncSnapshot<FileResponse> fileResponseSnapshot) {
                  final loading = !fileResponseSnapshot.hasData || fileResponseSnapshot.data is DownloadProgress;
                  if (!fileResponseSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (loading) {
                    return _Indicator(
                      downloadProgress: fileResponseSnapshot.data as DownloadProgress?,
                    );
                  }
                  FileInfo info = fileResponseSnapshot.data as FileInfo;
                  return ListView(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: implementation.clearCache,
                              child: const Text('Clear cache'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: implementation.removeFile,
                              child: const Text('Remove file'),
                            ),
                          ),
                        ],
                      ),
                      ListItem(
                        'Home URL',
                        'Base url address reference',
                        InternalColors.green,
                        info.originalUrl,
                      ),
                      ListItem(
                        'Local file path',
                        'This displays the local path to your file',
                        InternalColors.orange,
                        info.file.path,
                      ),
                      ListItem(
                        'Loaded from',
                        'This displays information about where the file was downloaded from',
                        InternalColors.blue,
                        info.source.toString(),
                      ),
                      ListItem(
                        'Valid until',
                        'This displays information about how long the file is valid for',
                        InternalColors.purple,
                        info.validTill.toIso8601String(),
                      ),
                      const SizedBox(height: 16)
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final DownloadProgress? downloadProgress;

  const _Indicator({this.downloadProgress});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator.adaptive(
              value: downloadProgress?.progress,
            ),
          ),
          const SizedBox(width: 20),
          const Text('Downloading'),
        ],
      ),
    );
  }
}
