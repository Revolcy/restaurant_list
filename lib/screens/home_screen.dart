import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_list_provider.dart';
import '../providers/search_provider.dart';
import '../utils/result_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;
import '../widgets/restaurant_card.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final listProv = context.watch<RestaurantListProvider>();
    final searchProv = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Restoran"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtl,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Cari restoran...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                searchProv.searchRestaurant(query);
              },
            ),
          ),

          // 📋 Konten
          Expanded(
            child: searchProv.lastQuery.isNotEmpty
                ? _buildSearch(searchProv)
                : _buildList(listProv),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(SearchProvider prov) {
    switch (prov.state) {
      case ResultState.loading:
        return const LoadingWidget();
      case ResultState.error:
        return custom.ErrorWidget(
          message: prov.message,
          onRetry: () => prov.searchRestaurant(prov.lastQuery),
        );
      case ResultState.hasData:
        return ListView.builder(
          itemCount: prov.results.length,
          itemBuilder: (context, i) {
            final r = prov.results[i];
            return RestaurantCard(
              restaurant: r,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      restaurantId: r.id,
                      restaurantName: r.name,
                    ),
                  ),
                );
              },
            );
          },
        );
      case ResultState.noData:
        return Center(child: Text(prov.message));
    }
  }

  Widget _buildList(RestaurantListProvider prov) {
    switch (prov.state) {
      case ResultState.loading:
        return const LoadingWidget();
      case ResultState.error:
        return custom.ErrorWidget(
          message: prov.message,
          onRetry: prov.fetchAllRestaurants,
        );
      case ResultState.hasData:
        return ListView.builder(
          itemCount: prov.restaurants.length,
          itemBuilder: (context, i) {
            final r = prov.restaurants[i];
            return RestaurantCard(
              restaurant: r,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      restaurantId: r.id,
                      restaurantName: r.name,
                    ),
                  ),
                );
              },
            );
          },
        );
      case ResultState.noData:
        return Center(child: Text(prov.message));
    }
  }
}
