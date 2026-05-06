import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/utils/base_view_model.dart';

import '../../repository/auth_repository.dart';

class RegisterProvider extends BaseViewModel {
  final AuthRepository _repo = AuthRepository();

  /// REGISTER
  Future<void> register(String name, String email, String password) async {
    setLoading();
    try {
      await _repo.register(name: name, email: email, password: password);
      setSuccess();
    } catch (e) {
      if (e is DioException) {
        setError(e.error.toString());
      } else {
        setError("Something went wrong");
      }
    }
  }

  /// LOGIN
  // Future<void> login(
  //     AppViewModel appVM,
  //     String email,
  //     String password,
  //     ) async {
  //
  //   setLoading();
  //
  //   try {
  //
  //     final result = await _repo.login(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final token = result.$1;
  //
  //     /// SAVE TOKEN + CHANGE APP STATE
  //     await appVM.setLoggedIn(token);
  //
  //     setSuccess();
  //
  //   } catch (e) {
  //     setError(e.toString());
  //   }
  // }
}
