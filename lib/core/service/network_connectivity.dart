import 'package:cross_connectivity/cross_connectivity.dart';

class NetworkConnectivity {
  final Connectivity connectivity;
  NetworkConnectivity({required this.connectivity});
  Future<bool> get status async {
    return await connectivity.checkConnection();
  }
}
