import 'package:flutter/foundation.dart';
import '../model/restaurant.dart';
import '../service/api_service.dart';
import '../utils/result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService, bool autoFetch = true}) {
    if (autoFetch) fetchAllRestaurants();
  }

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  List<Restaurant> _allRestaurants = [];

  Future<void> fetchAllRestaurants() async {
    _state = ResultState.loading;
    _message = '';
    notifyListeners();

    try {
      final data = await apiService.getListRestaurant();

      if (data.isEmpty) {
        _state = ResultState.noData;
        _message = "No restaurant found";
      } else {
        _allRestaurants = data;
        _restaurants = data;
        _state = ResultState.hasData;
      }
    } catch (e) {
      debugPrint("Error fetchAllRestaurants: $e");
      _state = ResultState.error;
      _message = "Failed to load restaurants. Try again";
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.trim().isEmpty) {
      _restaurants = _allRestaurants;
      if (_restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = "No restaurant found";
      } else {
        _state = ResultState.hasData;
        _message = "Showing all restaurants";
      }
      notifyListeners();
      return;
    }

    _state = ResultState.loading;
    _message = '';
    notifyListeners();

    try {
      final data = await apiService.searchRestaurant(query);

      if (data.isEmpty) {
        _state = ResultState.noData;
        _message = "Restaurant not found for '$query'";
      } else {
        _restaurants = data;
        _state = ResultState.hasData;
      }
    } catch (e) {
      debugPrint("Error searchRestaurants: $e");
      _state = ResultState.error;
      _message = "Failed to search restaurants. Try again";
    }
    notifyListeners();
  }
}
