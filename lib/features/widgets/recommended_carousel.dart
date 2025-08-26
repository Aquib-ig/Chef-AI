import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_ai/core/routes/app_routes.dart';
import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/features/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecommendedCarousel extends StatelessWidget {
  final List<Recipe> recipes;

  const RecommendedCarousel({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recommended for You',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // CarouselView with GoRouter Navigation
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: CarouselView(
            itemExtent: 300,
            shrinkExtent: 250,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: Colors.transparent,
            elevation: 0,
            itemSnapping: true,
            onTap: (index) {
              // Navigate using GoRouter
              final selectedRecipe = recipes.take(10).toList()[index];
              context.push(AppRoutes.recipeDetailScreen, extra: selectedRecipe);
            },
            children: recipes.take(10).map((recipe) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),

                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Recipe Image
                    Expanded(
                      child:                 ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: recipe.image ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                    ),

                    // Recipe Details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name ?? 'Unknown Recipe',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: isDark
                                        ? AppColors.primaryDark
                                        : AppColors.primaryLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(recipe.prepTimeMinutes ?? 0) + (recipe.cookTimeMinutes ?? 0)} min',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: isDark
                                        ? AppColors.secondaryDark
                                        : AppColors.secondaryLight,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${recipe.rating ?? 0.0}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
