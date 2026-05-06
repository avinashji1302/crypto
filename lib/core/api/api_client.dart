import 'package:app/core/api/api_endponts.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/secure_storage.dart';
import 'api_interceptor.dart';

class ApiClient {

  late final Dio dio;

  ApiClient() {

    final storage = SecureStorage();

    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(ApiInterceptor(storage));

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
      ),
    );
  }
}