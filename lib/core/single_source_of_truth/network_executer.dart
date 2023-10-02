// ignore_for_file: avoid_print

import 'package:todo/core/interface/api_client/base_client_generator.dart';
import 'package:todo/core/interface/models/base_network_model.dart';
import 'package:todo/core/interface/response/todo_error.dart';
import 'package:todo/core/interface/response/result.dart';
import 'package:todo/core/service/network_connectivity.dart';
import 'package:todo/core/service/network_creator.dart';
import 'package:todo/core/service/network_options/network_options.dart';
import 'network_decoder.dart';
import 'package:dio/dio.dart';

class NetworkExecuter {
  final NetworkConnectivity networkConnectivity;
  final NetworkCreator networkCreator;
  final NetworkDecoder networkDecoder;

  final bool debugMode;
  NetworkExecuter(
      {required this.networkConnectivity,
      required this.networkCreator,
      required this.networkDecoder,
      required this.debugMode});
  //T is model type K is response type
  Future<Result<K, TodoError>> execute<T extends BaseNetworkModel, K>(
      {required BaseClientGenerator route,
      required T responseType,
      dynamic mockData,
      NetworkOptions? options}) async {
    // Check Network Connectivity
    if (await networkConnectivity.status) {
      try {
        if (mockData != null) {
          var data = networkDecoder.decode<T, K>(
              response:
                  Response(data: mockData, requestOptions: RequestOptions()),
              responseType: responseType);
          return Result.success(data);
        }
        var response =
            await networkCreator.request(route: route, options: options);
        var data = networkDecoder.decode<T, K>(
            response: response, responseType: responseType);
        return Result.success(data);

        // NETWORK ERROR
      } on DioException catch (dioError) {
        if (debugMode) {
          print("$route => ${RequestError(error: dioError)}");
        }
        return Result.failure(RequestError(error: dioError));

        // TYPE ERROR
      } on TypeError catch (e) {
        if (debugMode) {
          print("$route => ${DecodingError(errMsg: e.toString())}");
        }
        return Result.failure(DecodingError(errMsg: e.toString()));
      }

      // No Internet Connection
    } else {
      if (debugMode) {
        print(ConnectivityError(errMsg: 'No Internet Connection'));
      }
    }
    return Result.failure(ConnectivityError(errMsg: 'No Internet Connection'));
  }
}
