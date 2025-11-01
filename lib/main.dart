import 'package:flutter/material.dart';
import 'package:portfolio/core/util/app_details.dart';
import 'package:portfolio/core/util/app_theme.dart';
import 'package:portfolio/features/splash/presentation/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInfo.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  SharedPreferences? _prefs;

  ThemeMode _themeMode = ThemeMode.dark;

  void _loadTheme() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (!_prefs!.containsKey('themeMode')) {
      // Default to dark theme if no preference is set
      _prefs!.setString('themeMode', 'dark');
    }
    final theme = _prefs!.getString('themeMode') ?? '';

    setState(() {
      _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleTheme() async {
    _prefs ??= await SharedPreferences.getInstance();

    // Toggle the theme
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
        _prefs!.setString('themeMode', 'dark');
      } else {
        _themeMode = ThemeMode.light;
        _prefs!.setString('themeMode', 'light');
      }
    });
  }

  @override
  void initState() {
    _loadTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Portfolio',
        themeMode: _themeMode,
        theme: lightTheme(),
        darkTheme: darkTheme(),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(toggleTheme: toggleTheme),
      );
  }
}
