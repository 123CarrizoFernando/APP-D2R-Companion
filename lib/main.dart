import 'package:flutter/material.dart';
import 'utils/app_colors.dart';
import 'screens/home_screen.dart';
import 'runewords_screen.dart';

void main() {
  runApp(const D2RCompanionApp());
}

class D2RCompanionApp extends StatelessWidget {
  const D2RCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'D2R Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.panel,
          foregroundColor: AppColors.uniqueGold,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.uniqueGold,
          secondary: AppColors.runeOrange,
          surface: AppColors.panel,
        ),
        // Más adelante podemos cargar e inyectar la fuente 'Exocet' de Diablo
        fontFamily: 'Roboto', 
      ),
      home: const HomeScreen(),
    );
  }
}