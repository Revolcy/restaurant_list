import 'package:flutter/material.dart';
import '../model/restaurant.dart';
import 'detail_screen.dart';
import '../widgets/restaurant_card.dart';

class SearchScreen extends StatelessWidget {
  final List<Restaurant> results;
  const SearchScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Pencarian")),
      body: results.isEmpty
          ? const Center(child: Text("Tidak ada hasil"))
          : ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final restaurant = results[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    restaurantId: restaurant.id,
                    restaurantName: restaurant.name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
