// ignore_for_file: unused_catch_clause, use_super_parameters

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({Key? key}) : super(key: key);

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  Connectivity connectivity = Connectivity();
  IconData? icon;
  String connectionType = "No internet connection";
  bool isOffline = true;
  late StreamSubscription<ConnectivityResult> connectionSubscription;

  @override
  void initState() {
    super.initState();
    getConnectivity();

    connectionSubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    connectionSubscription.cancel();
    super.dispose();
  }

  Future<void> getConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
      getConnectionType(result);
    } on PlatformException catch (e) {
      //developer.log('Couldn\'t check connectivity status', error: e);
      icon = Icons.signal_wifi_connected_no_internet_4;
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return updateConnectionStatus(result);
  }

  void getConnectionType(result) {
    if (result == ConnectivityResult.mobile) {
      connectionType = "Internet connection is from Mobile data";
      icon = Icons.network_cell;
    } else if (result == ConnectivityResult.wifi) {
      connectionType = "Internet connection is from wifi";
      icon = Icons.network_wifi_sharp;
    } else if (result == ConnectivityResult.ethernet) {
      connectionType = "Internet connection is from wired cable";
      icon = Icons.settings_ethernet;
    } else if (result == ConnectivityResult.bluetooth) {
      connectionType = "Internet connection is from Bluetooth tethering";
      icon = Icons.network_wifi_sharp;
    } else if (result == ConnectivityResult.none) {
      connectionType = "No internet connection";
      icon = Icons.signal_wifi_connected_no_internet_4;
    }
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    getConnectionType(result);

    if (result == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
    } else {
      setState(() {
        isOffline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
