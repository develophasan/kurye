import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1, // +1 for "Tümü" button
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryChip(
              context,
              'Tümü',
              selectedCategory == null,
              () => onCategorySelected(null),
            );
          }

          final category = categories[index - 1];
          return _buildCategoryChip(
            context,
            category,
            selectedCategory == category,
            () => onCategorySelected(category),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String category,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: ColorConstants.surface,
        selectedColor: ColorConstants.primary,
        checkmarkColor: ColorConstants.textWhite,
        labelStyle: TextStyle(
          color: isSelected ? ColorConstants.textWhite : ColorConstants.text,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
} 