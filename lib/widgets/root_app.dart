import 'package:flutter/material.dart';

import 'package:hendrix_today_app/objects/theme_data.dart';
import 'package:hendrix_today_app/objects/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:hendrix_today_app/screens/home_screen.dart';
import 'package:hendrix_today_app/screens/calendar_screen.dart';
import 'package:hendrix_today_app/screens/login_screen.dart';
import 'package:hendrix_today_app/screens/search_screen.dart';
import 'package:hendrix_today_app/screens/resource_screen.dart';

import '../screens/loading_screen.dart';
import '../screens/start_screen.dart';

/// The root widget in the app widget hierarchy.

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: Builder(builder: (BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: hendrixTodayLightMode,
            darkTheme: hendrixTodayDarkMode,
            themeMode: themeProvider.themeMode,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/home':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/loading':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const LoadingScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/start':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const StartScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/login':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/calendar':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const CalendarScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/search':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const SearchScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case '/resources':
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => const ResourcesScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                default:
                  return null;
              }
            },
            initialRoute: '/home',
            navigatorKey: navigatorKey,
          );
        }));
  }
}
