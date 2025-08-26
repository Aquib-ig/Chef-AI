import 'package:chef_ai/core/routes/app_router.dart';
import 'package:chef_ai/core/routes/app_routes.dart';
import 'package:chef_ai/core/themes/app_theme.dart';
import 'package:chef_ai/core/themes/theme_cubit.dart';
import 'package:chef_ai/features/presentation/auth_screen/bloc/auth_bloc.dart';
import 'package:chef_ai/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],
      child: MultiBlocListener(
        listeners: [
          // Global Auth Listener - Handles sign out immediately
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthInitial) {
                // User signed out - navigate immediately
                AppRouter.router.go(AppRoutes.signInScreen);
              }
            },
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Chef AI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
