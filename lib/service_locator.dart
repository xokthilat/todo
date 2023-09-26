import 'dart:io';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/core/router/todo_navigator.dart';
import 'package:todo/core/service/local/objectbox_service.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/core/service/network_creator.dart';
import 'package:todo/core/single_source_of_truth/network_decoder.dart';
import 'package:todo/core/single_source_of_truth/network_executer.dart';
import 'package:todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo/features/todo/domain/usecases/check_passcode.dart';
import 'package:todo/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo/features/todo/domain/usecases/get_auth_detail.dart';
import 'package:todo/features/todo/domain/usecases/set_last_online.dart';
import 'package:todo/features/todo/domain/usecases/set_last_touch.dart';
import 'package:todo/features/todo/domain/usecases/set_passcode.dart';
import 'package:todo/features/todo/presentation/bloc/passcode_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
      () => PasscodeBloc(checkPasscode: sl(), setPasscode: sl()));

  sl.registerLazySingleton(() => CheckPasscode(sl()));
  sl.registerLazySingleton(() => DeleteTodo(sl()));
  sl.registerLazySingleton(() => GetAuthDetail(sl()));
  sl.registerLazySingleton(() => SetLastOnline(sl()));
  sl.registerLazySingleton(() => SetLastTouch(sl()));
  sl.registerLazySingleton(() => SetPasscode(sl()));
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(
        networkExecuter: sl(),
        objectboxService: sl(),
        networkConnectivity: sl(),
      ));
  sl.registerLazySingleton(() => NetworkExecuter(
      debugMode: kDebugMode,
      networkConnectivity: sl(),
      networkCreator: sl(),
      networkDecoder: sl()));
  sl.registerLazySingleton(() => NetworkCreator(client: sl()));
  sl.registerLazySingleton(() => NetworkDecoder());
  sl.registerLazySingleton(() => NetworkConnectivity(connectivity: sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => TodoNavigator());

  final dir = Directory((await getApplicationDocumentsDirectory()).path);
  sl.registerLazySingleton(() => ObjectboxService(dir.path));
}
