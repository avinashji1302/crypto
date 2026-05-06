import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import 'api_netwrok_error.dart';

class ApiInterceptor extends Interceptor {

  final SecureStorage storage;

  ApiInterceptor(this.storage);

  /// REQUEST
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {

    final token = await storage.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    return handler.next(options);
  }

  /// RESPONSE
  @override
  void onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) {

    return handler.next(response);
  }



  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {

    final message = ApiErrorHandler.handle(err);

    handler.reject(
      err.copyWith(
        error: message,
      ),
    );
  }}