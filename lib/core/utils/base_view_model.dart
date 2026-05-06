import 'package:flutter/material.dart';

enum ViewState {
  idle,
  loading,
  success,
  error,
}

class BaseViewModel extends ChangeNotifier {

  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;

  void setLoading() {
    _state = ViewState.loading;
    notifyListeners();
  }

  void setSuccess() {
    _state = ViewState.success;
    notifyListeners();
  }

  void setError(String message) {
    _state = ViewState.error;
    _errorMessage = message;
    debugPrint("error message is : $message");
    notifyListeners();
  }

  void reset() {
    _state = ViewState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}