// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult? _connectivityResult;
  final _connectivityPlusPlugin = Connectivity();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await _connectivityPlusPlugin.checkConnectivity();
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('connectivity_plus_aurora'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running status: ${_connectivityResult?.name}'),
              StreamBuilder(
                stream: _connectivityPlusPlugin.onConnectivityChanged,
                builder: (BuildContext context,
                    AsyncSnapshot<ConnectivityResult> snapshot) {
                  return Text('Stream status: ${snapshot.data?.name}');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
