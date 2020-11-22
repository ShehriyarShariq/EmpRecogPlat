import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkConnectionUpdates {
  Future<StreamSubscription<ConnectivityResult>> getConnectivityUpdates();
}

class NetworkConnectionUpdatesImpl extends NetworkConnectionUpdates {
  final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkConnectionUpdatesImpl(this.connectionChecker, this.connectivity);

  bool isConnected = false;

  @override
  Future<StreamSubscription<ConnectivityResult>> getConnectivityUpdates() {
    var subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      print(result);
      // if (!isConnected && result != ConnectivityResult.none) {
      //   isConnected = await connectionChecker.hasConnection;
      //   print("CONNECTION STATUS: ${isConnected}");
      // } else if (isConnected && result == ConnectivityResult.none) {
      //   isConnected = false;
      //   print("CONNECTION STATUS: ${isConnected}");
      // }
    });

    return Future.value(subscription);
  }
}
