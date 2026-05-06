import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {

  static String handle(DioException error) {

    /// ✅ Backend response error
    if (error.response != null &&
        error.response?.data != null) {

      final data = error.response!.data;

      if (data is Map && data["message"] != null) {
        return data["message"];
      }
    }

    /// ✅ Timeout
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return "Connection timeout";
    }

    /// ✅ No internet
    if (error.type == DioExceptionType.connectionError) {
      return "No internet connection";
    }

    /// ✅ Cancelled
    if (error.type == DioExceptionType.cancel) {
      return "Request cancelled";
    }

    /// ✅ Default
    return "Something went wrong";
  }
}