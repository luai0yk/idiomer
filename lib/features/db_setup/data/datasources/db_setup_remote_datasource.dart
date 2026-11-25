import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class NoInternetException implements Exception {
  const NoInternetException();

  @override
  String toString() => 'NoInternetException: No internet connection available.';
}

abstract class DbSetupRemoteDataSource {
  Future<bool> hasInternetConnection();
  Future<void> downloadDatabase({
    required String url,
    required String savePath,
    required void Function(int received, int total) onProgress,
    CancelToken? cancelToken,
  });
}

class DbSetupRemoteDataSourceImpl implements DbSetupRemoteDataSource {
  final Dio _dio;
  final Connectivity _connectivity;

  DbSetupRemoteDataSourceImpl({Dio? dio, Connectivity? connectivity})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(minutes: 2),
              sendTimeout: const Duration(seconds: 20),
            ),
          ),
      _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> hasInternetConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  @override
  Future<void> downloadDatabase({
    required String url,
    required String savePath,
    required void Function(int received, int total) onProgress,
    CancelToken? cancelToken,
  }) async {
    final file = File(savePath);
    await file.parent.create(recursive: true);

    await _dio.download(
      url,
      savePath,
      cancelToken: cancelToken,
      deleteOnError: true,
      onReceiveProgress: onProgress,
    );
  }
}
