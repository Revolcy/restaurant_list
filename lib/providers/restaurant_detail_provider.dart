import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import '../service/api_service.dart';
import '../utils/result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  RestaurantDetailProvider({required this.apiService, required this.id}) {
    fetchDetail();
  }

  Restaurant? _restaurant;
  Restaurant? get restaurant => _restaurant;

  List<CustomerReview> _reviews = [];
  List<CustomerReview> get reviews => _reviews;

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  String _message = "";
  String get message => _message;

  Future<void> fetchDetail() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final detail = await apiService.fetchRestaurantDetail(id);
      _restaurant = detail;
      _reviews = detail.customerReviews;
      _state = ResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = "Failed to load restaurant detail. Try again";
      notifyListeners();
    }
  }

  Future<bool> addReview({required String name, required String review}) async {
    try {
      final newReview = await apiService.postReview(
        id: id,
        name: name,
        review: review,
      );
      _reviews = newReview;
      notifyListeners();
      return true;
    } catch (e) {
      _message = "Failed to add review.";
      notifyListeners();
      return false;
    }
  }
}
