
import 'package:app/features/auth/login/model/login_model.dart';
import 'package:app/features/auth/repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/base_view_model.dart';

class LoginProvider extends BaseViewModel {
  final AuthRepository _repo = AuthRepository();
  LoginResponseModel? loginResponse;

  Future<void> login(
    String email,
    String password, {
    required VoidCallback onSuccess, // ← called when login works
    required Function(String) onError, // ← called with error message
  }) async {
    setLoading();

    try {
      final response = await _repo.login(email: email, password: password);
      debugPrint("response is : $response");

      if (response != null) {
        loginResponse = response;
      }

      setSuccess();
      onSuccess();
    }

    catch (e) {
      if (e is DioException) {
        setError(e.error.toString());
        onError(e.toString());
      } else {
        setError("Something went wrong");
        onError(e.toString());
      }
    }

  }
}
