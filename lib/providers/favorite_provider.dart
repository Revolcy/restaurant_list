import 'package:flutter/material.dart';
import '../data/favorite_db_helper.dart';
import '../model/restaurant.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteDbHelper dbHelper;

  FavoriteProvider({required this.dbHelper}) {
    _getFavorites();
  }

  List<Restaurant> _favorites = [];
  List<Restaurant> get favorites => _favorites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> _getFavorites() async {
    _isLoading = true;
    notifyListeners();

    final data = await dbHelper.getFavorites();
    _favorites = data.map((e) => Restaurant.fromMap(e)).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await dbHelper.insertFavorite(restaurant);
    await _getFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await dbHelper.removeFavorite(id);
    await _getFavorites();
  }

  bool isFavoriteSync(String id) {
    return _favorites.any((r) => r.id == id);
  }

  bool isFavorite(String id) => isFavoriteSync(id);

  Future<void> toggleFavorite(Restaurant restaurant) async {
    if (isFavoriteSync(restaurant.id)) {
      await removeFavorite(restaurant.id);
    } else {
      await addFavorite(restaurant);
    }
  }
}
