import 'package:chef_ai/core/routes/app_routes.dart';
import 'package:chef_ai/core/themes/app_colors.dart';
import 'package:chef_ai/core/utils/debouncer.dart';
import 'package:chef_ai/features/models/user_model.dart';
import 'package:chef_ai/features/models/user_service.dart';
import 'package:chef_ai/features/presentation/recipe_screens/bloc/recipe_bloc.dart';
import 'package:chef_ai/features/presentation/recipe_screens/widgets/category_chip.dart';
import 'package:chef_ai/features/widgets/gradient_container.dart';
import 'package:chef_ai/features/widgets/recipe_card.dart';
import 'package:chef_ai/features/widgets/recommended_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  final UserService _userService = UserService();
  UserModel? _currentUser;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(FetchRecipes());
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _userService.getCurrentUserData();
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  void _onCategorySelected(String category) {
    context.read<RecipeBloc>().add(CategorySelected(category));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GradientContainer(
          isDark: isDark,
          child: BlocBuilder<RecipeBloc, RecipeState>(
            builder: (context, state) {
              if (state is RecipeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is RecipeLoaded) {
                return CustomScrollView(
                  slivers: [
                    // Main SliverAppBar with header + search
                    SliverAppBar(
                      expandedHeight: 150,
                      floating: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? AppColors.darkWarmGradient
                                  : AppColors.lightWarmGradient,
                            ),
                          ),
                          child: SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // User Profile & Greeting
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Profile Picture or Initial
                                        _buildUserAvatar(isDark),
                                        const SizedBox(width: 12),

                                        // Greeting Text
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                _getGreeting(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: isDark
                                                          ? AppColors
                                                                .textSecondaryDark
                                                          : AppColors
                                                                .textSecondaryLight,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Hello, ${_currentUser?.name.split(' ').first ?? 'Chef'}!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color: isDark
                                                          ? AppColors
                                                                .textPrimaryDark
                                                          : AppColors
                                                                .textPrimaryLight,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'What to cook today?',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                      color: isDark
                                                          ? AppColors
                                                                .textSecondaryDark
                                                          : AppColors
                                                                .textSecondaryLight,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Notification Icon
                                  GestureDetector(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.notificationScreen,
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.surfaceDark
                                            : AppColors.surfaceLight,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: isDark
                                            ? AppColors.primaryDark
                                            : AppColors.primaryLight,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: _buildSearchBar(isDark),
                        ),
                      ),
                    ),

                    // Rest of your existing slivers...
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          RecommendedCarousel(
                            recipes: context
                                .read<RecipeBloc>()
                                .recommendedRecipe,
                          ),

                          const SizedBox(height: 20),

                          // Category section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Categories',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimaryLight,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                CategoryChips(
                                  onCategorySelected: _onCategorySelected,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // All recipes header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Recipes (${state.recipes.length})',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimaryLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),

                    if (state.recipes.isEmpty)
                      SliverToBoxAdapter(child: _buildEmptyState())
                    else
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final recipe = state.recipes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: RecipeCard(
                              imageUrl: recipe.image ?? "",
                              title: recipe.name ?? "Unknown Recipe",
                              prepTimeMinutes: recipe.prepTimeMinutes ?? 0,
                              cookTimeMinutes: recipe.cookTimeMinutes ?? 0,
                              rating: recipe.rating ?? 0.0,
                              reviewCount: recipe.reviewCount ?? 0,
                              isSaved: _isSaved(recipe.id ?? 0),
                              onTap: () {
                                context.push(
                                  AppRoutes.recipeDetailScreen,
                                  extra: recipe,
                                );
                              },
                              onSaveTap: () =>
                                  _toggleSaveRecipe(recipe.id ?? 0),
                            ),
                          );
                        }, childCount: state.recipes.length),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              } else if (state is RecipeError) {
                return _buildErrorState(isDark, state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  // Build User Avatar - Show profile pic or first letter
  Widget _buildUserAvatar(bool isDark) {
    final hasProfilePic =
        _currentUser?.profilePicUrl != null &&
        _currentUser!.profilePicUrl!.isNotEmpty;

    if (hasProfilePic) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(_currentUser!.profilePicUrl!),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? AppColors.primaryDark.withOpacity(0.3)
                  : AppColors.primaryLight.withOpacity(0.3),
              width: 2,
            ),
          ),
        ),
      );
    } else {
      // Show first letter of name[65][69]
      final firstLetter = _currentUser?.name.isNotEmpty == true
          ? _currentUser!.name.substring(0, 1).toUpperCase()
          : 'C'; // Default to 'C' for Chef

      return CircleAvatar(
        radius: 25,
        backgroundColor: isDark
            ? AppColors.primaryDark
            : AppColors.primaryLight,
        child: Text(
          firstLetter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  // Get time-based greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Rest of your existing methods remain the same...
  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'Search for delicious recipes...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.hintTextDark : AppColors.hintTextLight,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    context.read<RecipeBloc>().add(SearchRecipes(''));
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (query) {
          _debouncer.run(() {
            context.read<RecipeBloc>().add(SearchRecipes(query));
          });
          setState(() {});
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.restaurant_menu_rounded,
                size: 64,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No recipes found in this category',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try selecting a different category or search for something else',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDark, String message) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Chef AI',
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Failed to load recipes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool _isSaved(int recipeId) {
    return recipeId % 3 == 0;
  }

  void _toggleSaveRecipe(int recipeId) {
    final isSaved = _isSaved(recipeId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved ? 'Recipe removed from saved' : 'Recipe saved successfully!',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
