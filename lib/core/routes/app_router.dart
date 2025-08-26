import 'package:chef_ai/core/routes/app_routes.dart';
import 'package:chef_ai/core/themes/theme_cubit.dart';
import 'package:chef_ai/features/presentation/ai_assistant_screen/ai_assistant_page.dart';
import 'package:chef_ai/features/presentation/ai_assistant_screen/bloc/ai_assistant_bloc.dart';
import 'package:chef_ai/features/presentation/app_screens/home_screen.dart';
import 'package:chef_ai/features/presentation/app_screens/splash_screen.dart';
import 'package:chef_ai/features/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:chef_ai/features/presentation/auth_screen/forget_password_screen.dart';
import 'package:chef_ai/features/presentation/auth_screen/signin_screen.dart';
import 'package:chef_ai/features/presentation/auth_screen/signup_screen.dart';
import 'package:chef_ai/features/presentation/notification_screen/notification_screen.dart';
import 'package:chef_ai/features/presentation/profile_screens/profile_page.dart';
import 'package:chef_ai/features/presentation/recipe_screens/bloc/recipe_bloc.dart';
import 'package:chef_ai/features/presentation/recipe_screens/recipe_detail_screen.dart';
import 'package:chef_ai/features/presentation/save_recipe_screens/saved_recipes_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splashScreen,
    redirect: (BuildContext context, GoRouterState state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoggedIn = user != null;
      final isAuthRoute = [
        AppRoutes.signInScreen,
        AppRoutes.signUpScreen,
        AppRoutes.forgotPasswordScreen,
      ].contains(state.matchedLocation);

      // Allow splash screen to always load first
      if (state.matchedLocation == AppRoutes.splashScreen) {
        return null;
      }

      // If user is not logged in and trying to access protected routes
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.signInScreen;
      }

      // If user is logged in and trying to access auth routes
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.homeScreen;
      }

      return null; // No redirect needed
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: AppRoutes.signInScreen,
        builder: (context, state) {
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
            child: const SignInScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.signUpScreen,
        builder: (context, state) {
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
            child: const SignUpScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) {
          return BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
            child: const ForgotPasswordScreen(),
          );
        },
      ),

      // Home Screen with Multiple BLoCs
      GoRoute(
        path: AppRoutes.homeScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
              BlocProvider<RecipeBloc>(create: (context) => RecipeBloc()),
              BlocProvider<AiAssistantBloc>(
                create: (context) => AiAssistantBloc(),
              ),
            ],
            child: const HomeScreen(),
          );
        },
      ),

      // Recipe Detail Screen
      GoRoute(
        path: AppRoutes.recipeDetailScreen,
        builder: (context, state) {
          final recipe = state.extra;
          if (recipe == null) {
            return const Scaffold(
              body: Center(child: Text('Recipe not found')),
            );
          }
          return BlocProvider<RecipeBloc>(
            create: (context) => RecipeBloc(),
            child: RecipeDetailScreen(recipe: recipe),
          );
        },
      ),

      // AI Search Screen
      GoRoute(
        path: AppRoutes.aiSearch,
        builder: (context, state) {
          return BlocProvider<AiAssistantBloc>(
            create: (context) => AiAssistantBloc(),
            child: const AIAssistantPage(),
          );
        },
      ),

      // Saved Recipes Screen
      GoRoute(
        path: AppRoutes.savedScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<RecipeBloc>(create: (context) => RecipeBloc()),
              BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
            ],
            child: const SavedRecipesPage(),
          );
        },
      ),

      // Profile Screen - FIXED WITH BOTH BLOCS
      GoRoute(
        path: AppRoutes.profileScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
              BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
            ],
            child: const ProfileSettingsScreen(),
          );
        },
      ),

      // Notification Screen
      GoRoute(
        path: AppRoutes.notificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.homeScreen),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
