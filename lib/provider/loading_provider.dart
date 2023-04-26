import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
  bool _loading = false;

  bool get loadingStatus => _loading;

  loading(bool status) {
    _loading = status;
    notifyListeners();
  }
}
