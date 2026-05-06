import 'package:flutter/material.dart';
import '../storage/secure_storage.dart';

enum AppStatus {
  initializing,
  authenticated,
  unauthenticated,
}

class AppViewModel extends ChangeNotifier {

  final SecureStorage _storage = SecureStorage();

  AppStatus _status = AppStatus.initializing;

  AppStatus get status => _status;

  /// APP START
  Future<void> initializeApp() async {

    final token = await _storage.getToken();

    if (token != null) {
      _status = AppStatus.authenticated;
    } else {
      _status = AppStatus.unauthenticated;
    }

    notifyListeners();
  }

  /// LOGIN SUCCESS
  Future<void> setLoggedIn(String token) async {
    await _storage.saveToken(token);
    _status = AppStatus.authenticated;
    notifyListeners();
  }

  /// LOGOUT
  Future<void> logout() async {
    await _storage.clear();
    _status = AppStatus.unauthenticated;
    notifyListeners();
  }
}