import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'injection.dart' as di;
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/blocs/theme/theme_cubit.dart';
import 'presentation/blocs/locale/locale_cubit.dart';
import 'presentation/blocs/cart/cart_cubit.dart';
import 'presentation/blocs/meal/meal_cubit.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Dependency Injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
        BlocProvider(create: (_) => di.sl<MealCubit>()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp(
                title: 'StreetBite',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
