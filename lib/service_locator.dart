import 'dart:io';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/core/service/network_creator.dart';
import 'package:todo/core/single_source_of_truth/network_decoder.dart';
import 'package:todo/core/single_source_of_truth/network_executer.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => NetworkExecuter(
      debugMode: true,
      networkConnectivity: sl(),
      networkCreator: sl(),
      networkDecoder: sl()));
  sl.registerLazySingleton(() => NetworkCreator(client: sl()));
  sl.registerLazySingleton(() => NetworkDecoder());
  sl.registerLazySingleton(() => NetworkConnectivity(connectivity: sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());

  final dir = Directory((await getApplicationDocumentsDirectory()).path);
  sl.registerLazySingleton(() => ObjectboxService(dir.path));
}
