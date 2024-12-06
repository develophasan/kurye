import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/models/restaurant_model.dart';
import '../viewmodel/home_view_model.dart';
import '../widgets/category_list.dart';
import '../widgets/nearby_restaurants.dart';
import '../widgets/restaurant_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final viewModel = context.read<HomeViewModel>();
    await viewModel.getAllRestaurants();
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;

      final viewModel = context.read<HomeViewModel>();
      await viewModel.getNearbyRestaurants(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      debugPrint('Konum alınamadı: $e');
    }
  }

  void _onCategorySelected(String? category) {
    final viewModel = context.read<HomeViewModel>();
    if (category == null) {
      viewModel.clearCategoryFilter();
    } else {
      viewModel.getRestaurantsByCategory(category);
    }
  }

  void _onRestaurantSelected(RestaurantModel restaurant) {
    // TODO: Restoran detay sayfasına yönlendir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading && viewModel.restaurants.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (viewModel.error != null && viewModel.restaurants.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bir hata oluştu',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.error!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstants.textLight,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initializeData,
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  title: const Text('Kur-Ye'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // TODO: Arama sayfasına yönlendir
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      CategoryList(
                        categories: viewModel.categories,
                        selectedCategory: viewModel.selectedCategory,
                        onCategorySelected: _onCategorySelected,
                      ),
                      const SizedBox(height: 24),
                      NearbyRestaurants(
                        restaurants: viewModel.nearbyRestaurants,
                        onRestaurantSelected: _onRestaurantSelected,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          viewModel.selectedCategory ?? 'Tüm Restoranlar',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final restaurant = viewModel.restaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onTap: () => _onRestaurantSelected(restaurant),
                      );
                    },
                    childCount: viewModel.restaurants.length,
                  ),
                ),
                if (viewModel.isLoading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
} 