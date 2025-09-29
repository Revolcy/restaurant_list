import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../service/api_service.dart';
import '../utils/result_state.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;
  SearchProvider({required this.apiService});

  List<Restaurant> _results = [];
  List<Restaurant> get results => _results;

  ResultState _state = ResultState.noData;
  ResultState get state => _state;

  String _message = "";
  String get message => _message;

  String _lastQuery = "";
  String get lastQuery => _lastQuery;

  Future<void> searchRestaurant(String query) async {
    if (query.trim().isEmpty) {
      _setState(ResultState.noData, message: "Type the restaurant's name");
      return;
    }

    _lastQuery = query;
    _setState(ResultState.loading);

    try {
      final result = await apiService.searchRestaurant(query);

      if (result.isEmpty) {
        _setState(ResultState.noData, message: "Restaurant not found");
      } else {
        _results = result;
        _setState(ResultState.hasData);
      }
    } catch (e) {
      _setState(ResultState.error, message: "Error: $e");
    }
  }

  void _setState(ResultState newState, {String message = ""}) {
    _state = newState;
    _message = message;
    notifyListeners();
  }
}
