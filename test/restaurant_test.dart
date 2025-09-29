import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_dicoding/model/restaurant.dart';
import 'package:restaurant_dicoding/providers/restaurant_list_provider.dart';
import 'package:restaurant_dicoding/providers/search_provider.dart';
import 'package:restaurant_dicoding/service/api_service.dart';
import 'package:restaurant_dicoding/utils/result_state.dart';

void main() {
  group('RestaurantListProvider Tests', () {
    late RestaurantListProvider provider;

    test('Initial state should be loading', () {
      provider = RestaurantListProvider(
        apiService: MockApiService(),
        autoFetch: false,
      );

      expect(provider.state, equals(ResultState.loading));
      expect(provider.restaurants, isEmpty);
      expect(provider.message, isEmpty);
    });

    test('Should return list of restaurants when API call succeeds', () async {
      provider = RestaurantListProvider(
        apiService: MockApiService(),
        autoFetch: false,
      );

      await provider.fetchAllRestaurants();

      expect(provider.state, equals(ResultState.hasData));
      expect(provider.restaurants, isNotEmpty);
      expect(provider.message, isEmpty);
    });

    test('Should return error when API call fails', () async {
      provider = RestaurantListProvider(
        apiService: FailingApiService(),
        autoFetch: false,
      );

      await provider.fetchAllRestaurants();

      expect(provider.state, equals(ResultState.error));
      expect(provider.restaurants, isEmpty);
      expect(provider.message, isNotEmpty);
    });
  });

  group('SearchProvider Tests', () {
    test('Search should return no data when query not found', () async {
      final searchProvider = SearchProvider(apiService: EmptyApiService());

      await searchProvider.searchRestaurant('xyz');
      expect(searchProvider.state, equals(ResultState.noData));
      expect(searchProvider.message, contains('not found'));
    });

    test('Search should set error state when API fails', () async {
      final searchProvider = SearchProvider(apiService: FailingApiService());

      await searchProvider.searchRestaurant('abc');
      expect(searchProvider.state, equals(ResultState.error));
      expect(searchProvider.message, contains('Error'));
    });
  });
}

/// Mock API sukses
class MockApiService implements ApiService {
  @override
  Future<List<Restaurant>> getListRestaurant() async {
    return [
      Restaurant(
        id: 'r1',
        name: 'Test Resto',
        description: 'Desc',
        pictureId: '1',
        city: 'City',
        rating: 4.0,
      ),
    ];
  }

  @override
  Future<Restaurant> fetchRestaurantDetail(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CustomerReview>> postReview({
    required String id,
    required String name,
    required String review,
  }) async {
    return [];
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String query) async {
    return [];
  }
}

class FailingApiService implements ApiService {
  @override
  Future<List<Restaurant>> getListRestaurant() {
    throw Exception('API gagal');
  }

  @override
  Future<Restaurant> fetchRestaurantDetail(String id) {
    throw Exception('API gagal detail');
  }

  @override
  Future<List<CustomerReview>> postReview({
    required String id,
    required String name,
    required String review,
  }) {
    throw Exception('API gagal post review');
  }

  @override
  Future<List<Restaurant>> searchRestaurant(String query) {
    throw Exception('API gagal search');
  }
}

/// Mock API kosong
class EmptyApiService implements ApiService {
  @override
  Future<List<Restaurant>> getListRestaurant() async => [];

  @override
  Future<Restaurant> fetchRestaurantDetail(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CustomerReview>> postReview({
    required String id,
    required String name,
    required String review,
  }) async => [];

  @override
  Future<List<Restaurant>> searchRestaurant(String query) async => [];
}
