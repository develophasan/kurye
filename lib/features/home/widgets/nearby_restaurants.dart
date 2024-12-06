import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/models/restaurant_model.dart';

class NearbyRestaurants extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  final ValueChanged<RestaurantModel> onRestaurantSelected;

  const NearbyRestaurants({
    super.key,
    required this.restaurants,
    required this.onRestaurantSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (restaurants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Yakınınızdaki Restoranlar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return _NearbyRestaurantCard(
                restaurant: restaurant,
                onTap: () => onRestaurantSelected(restaurant),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbyRestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const _NearbyRestaurantCard({
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: restaurant.images.isNotEmpty
                      ? Image.network(
                          restaurant.images.first,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: ColorConstants.shimmerBase,
                          child: const Icon(
                            Icons.restaurant,
                            size: 48,
                            color: ColorConstants.shimmerHighlight,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: ColorConstants.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: ColorConstants.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.averageDeliveryTime} dk',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 