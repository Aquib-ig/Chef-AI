import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RecipeDetailScreen extends StatefulWidget {
  final dynamic recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Recipe Image
              SizedBox(
                height: 400,
                width: double.infinity,
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: widget.recipe.image ?? "",
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ),
                    );
                  },
                ),
              ),

              // Back Button
              Positioned(
                top: 25,
                left: 15,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.borderLight.withOpacity(0.9),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                  ),
                ),
              ),

              // Save Button
              Positioned(
                top: 25,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.borderLight.withOpacity(0.9),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSaved = !isSaved;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSaved
                                ? 'Recipe saved!'
                                : 'Recipe removed from saved',
                          ),
                          backgroundColor: isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight,
                        ),
                      );
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                  ),
                ),
              ),

              // Recipe Details Container
              Positioned(
                top: 350,
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark.withOpacity(0.8)
                          : AppColors.surfaceLight.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: DefaultTabController(
                      length: 3, // Changed to 3 tabs
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe Title
                          Text(
                            widget.recipe.name ?? "Unknown Recipe",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                ),
                          ),

                          const SizedBox(height: 8),

                          // Recipe Info Row
                          Row(
                            children: [
                              Text(
                                "Servings: ${widget.recipe.servings ?? "N/A"}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.access_time_rounded,
                                color: isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${widget.recipe.prepTimeMinutes ?? 0} + ${widget.recipe.cookTimeMinutes ?? 0} min",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // TabBar with 3 tabs
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.inputFillDark
                                  : AppColors.inputFillLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                              indicator: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? AppColors.buttonDarkGradient
                                      : AppColors.buttonLightGradient,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: const [
                                Tab(text: "Ingredients"),
                                Tab(text: "Instructions"),
                                Tab(text: "Reviews"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // TabBarView with 3 tabs
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Ingredients Tab
                                _buildIngredientsTab(isDark),

                                // Instructions Tab
                                _buildInstructionsTab(isDark),

                                // Reviews Tab
                                _buildReviewsTab(isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ingredients Tab Content
  Widget _buildIngredientsTab(bool isDark) {
    return ListView.builder(
      itemCount: widget.recipe.ingredients?.length ?? 0,
      itemBuilder: (context, index) {
        final ingredient = widget.recipe.ingredients![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? AppColors.buttonDarkGradient
                        : AppColors.buttonLightGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Instructions Tab Content
  Widget _buildInstructionsTab(bool isDark) {
    return ListView.builder(
      itemCount: widget.recipe.instructions?.length ?? 0,
      itemBuilder: (context, index) {
        final instruction = widget.recipe.instructions![index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? AppColors.buttonDarkGradient
                        : AppColors.buttonLightGradient,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instruction,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Reviews Tab Content
  Widget _buildReviewsTab(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Rating Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.inputFillDark
                  : AppColors.inputFillLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${widget.recipe.rating ?? 0.0}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                RatingBarIndicator(
                  rating: widget.recipe.rating ?? 0.0,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: isDark
                        ? AppColors.secondaryDark
                        : AppColors.secondaryLight,
                  ),
                  itemCount: 5,
                  itemSize: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on ${widget.recipe.reviewCount ?? 0} reviews',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Recent Reviews',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 16),

          // Mock Reviews (since API doesn't provide individual reviews)
          ...List.generate(5, (index) => _buildReviewItem(index, isDark)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index, bool isDark) {
    final mockReviews = [
      {
        'name': 'Sarah M.',
        'rating': 5.0,
        'comment': 'Absolutely delicious! Easy to follow instructions.',
      },
      {
        'name': 'Mike T.',
        'rating': 4.0,
        'comment': 'Great recipe, but took a bit longer than expected.',
      },
      {
        'name': 'Emma L.',
        'rating': 5.0,
        'comment': 'Perfect for family dinner. Kids loved it!',
      },
      {
        'name': 'John D.',
        'rating': 4.0,
        'comment': 'Good flavors, will definitely make again.',
      },
      {
        'name': 'Lisa K.',
        'rating': 5.0,
        'comment': 'Amazing! Better than restaurant quality.',
      },
    ];

    final review = mockReviews[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
                radius: 20,
                child: Text(
                  review['name'].toString().substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'].toString(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RatingBarIndicator(
                      rating: review['rating'] as double,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: isDark
                            ? AppColors.secondaryDark
                            : AppColors.secondaryLight,
                      ),
                      itemCount: 5,
                      itemSize: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'].toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
