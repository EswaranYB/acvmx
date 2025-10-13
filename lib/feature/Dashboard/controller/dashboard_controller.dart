import 'package:flutter/material.dart';

class DashBoardController extends ChangeNotifier {
  String _currentPage;

  DashBoardController({required String initialPage}) : _currentPage = initialPage;

  String get currentPage => _currentPage;

  void updatePage(String pageName) {
    _currentPage = pageName;
    notifyListeners();
  }
}
