import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio? _dio;

  static Dio? get dio {
    _dio ??= Dio();

    return _dio;
  }

  @visibleForTesting
  static set dio(Dio? value) {
    _dio = value;
  }

  Future<Either<String, Response>> post({
    required String url,
    dynamic data,
  }) async {
    try {
      final response = await dio!.post(url, data: data);

      return Right(response);
    } on DioError catch (e) {
      return Left(e.message);
    }
  }

  Future<Either<String, Response>> get({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await dio!.get(url, queryParameters: params);

      return Right(response);
    } on DioError catch (e) {
      return Left(e.message);
    }
  }
}
