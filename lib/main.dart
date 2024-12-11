import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Connectivity Plus Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConnectivityChecker(),
    );
  }
}

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectivityStatus(result);
      log("isAvalible >> $isConnected");
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      debugPrint("Failed to get connectivity: $e");
    }
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    isConnected.value =
        results.any((result) => result != ConnectivityResult.none);
  }

  Future<bool> isInternetAvailable() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}

class ConnectivityChecker extends StatelessWidget {
  const ConnectivityChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final ConnectivityController connectivityController =
        Get.put(ConnectivityController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Checker'),
      ),
      body: Center(
        child: Obx(() => Text(
              connectivityController.isConnected.value
                  ? 'Connected to the Internet'
                  : 'No Internet Connection',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
