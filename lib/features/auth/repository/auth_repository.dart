import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/api/api_client.dart';
import '../../../core/api/api_endponts.dart';
import '../login/model/login_model.dart';
import '../register/model/register_model.dart';


class AuthRepository {

  final Dio _dio = ApiClient().dio;

  /// REGISTER
  Future<RegisterModel> register({
    required String name,
    required String email,
    required String password,
  }) async {

    final response = await _dio.post(
      ApiEndpoints.register,
      data: {
        "name": name,
        "email": email,
        "password": password,
      },
    );

    debugPrint("response : $response");

    return RegisterModel.fromJson(response.data["user"]);
  }

  // /// LOGIN
  Future<(dynamic, UserModel)> login({
    required String email,
    required String password,
  }) async {

    final response = await _dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    final token = response.data["accessToken"];
    final user = UserModel.fromJson(response.data["user"]);

    debugPrint("response is : $response ${token} $user");

    return (token, user);
  }
}