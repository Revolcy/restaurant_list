import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_detail_provider.dart';
import '../providers/favorite_provider.dart';
import '../model/restaurant.dart';
import '../service/api_service.dart';
import '../utils/result_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

class DetailScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const DetailScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDetailProvider(
        apiService: ApiService(),
        id: widget.restaurantId,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurantName),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, _) {
            switch (provider.state) {
              case ResultState.loading:
                return const LoadingWidget();
              case ResultState.error:
                return custom.ErrorWidget(
                  message: provider.message,
                  onRetry: () => provider.fetchDetail(),
                );
              case ResultState.noData:
                return Center(child: Text(provider.message));
              case ResultState.hasData:
                final restaurant = provider.restaurant!;
                return _buildDetail(restaurant, provider);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetail(Restaurant restaurant, RestaurantDetailProvider provider) {
    final favProv = context.watch<FavoriteProvider>();
    final isFav = favProv.isFavoriteSync(restaurant.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: "resto-${restaurant.id}",
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        restaurant.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => favProv.toggleFavorite(restaurant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${restaurant.city} • ⭐ ${restaurant.rating}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  "${restaurant.address}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  restaurant.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),

                // Menu
                Text("Menu Makanan", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (restaurant.menus?.foods != null &&
                    restaurant.menus!.foods.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: restaurant.menus!.foods
                        .map((f) => Chip(label: Text(f.name)))
                        .toList(),
                  )
                else
                  const Text("Tidak ada data makanan"),
                const SizedBox(height: 16),
                Text("Menu Minuman", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (restaurant.menus?.drinks != null &&
                    restaurant.menus!.drinks.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: restaurant.menus!.drinks
                        .map((d) => Chip(label: Text(d.name)))
                        .toList(),
                  )
                else
                  const Text("Tidak ada data minuman"),
                const SizedBox(height: 24),

                // Reviews
                Text("Customer Reviews", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (restaurant.customerReviews.isNotEmpty)
                  Column(
                    children: restaurant.customerReviews.map((review) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(review.name),
                          subtitle: Text(review.review),
                          trailing: Text(
                            review.date,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  const Text("Belum ada review"),

                const SizedBox(height: 24),

                // Form tambah review
                Text("Tambah Review", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Anda",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _reviewController,
                  decoration: const InputDecoration(
                    labelText: "Review",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _addReview(provider),
                  child: const Text("Kirim Review"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addReview(RestaurantDetailProvider provider) async {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      _showSnackBar("Nama dan review harus diisi");
      return;
    }

    final success = await provider.addReview(
      name: name,
      review: review,
    );

    if (!mounted) return;

    if (success) {
      _nameController.clear();
      _reviewController.clear();
      _showSnackBar("Review berhasil ditambahkan");
    } else {
      _showSnackBar("Gagal menambahkan review");
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}