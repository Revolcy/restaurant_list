import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/restaurant.dart';

class ApiService {
  static const String baseUrl = "https://restaurant-api.dicoding.dev";

  // Get List of Restaurants
  Future<List<Restaurant>> getListRestaurant() async {
    final response = await http.get(Uri.parse("$baseUrl/list"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List restaurants = data["restaurants"];
      return restaurants.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load restaurants");
    }
  }

  // Get Detail of Restaurant
  Future<Restaurant> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Restaurant.fromJson(data["restaurant"]);
    } else {
      throw Exception("Failed to load restaurant detail");
    }
  }

  // Search Restaurant
  Future<List<Restaurant>> searchRestaurant(String query) async {
    final response = await http.get(Uri.parse("$baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List restaurants = data["restaurants"];
      return restaurants.map((e) => Restaurant.fromJson(e)).toList();
    } else {
      throw Exception("Failed to search restaurant");
    }
  }

  // Post Review
  Future<List<CustomerReview>> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/review"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": id, "name": name, "review": review}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      final List reviews = data["customerReviews"];
      return reviews.map((e) => CustomerReview.fromJson(e)).toList();
    } else {
      throw Exception("Failed to post review");
    }
  }
}
