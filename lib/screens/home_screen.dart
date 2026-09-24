import 'package:flutter/material.dart';
import 'builds_screen.dart';
import 'calculator_screen.dart';
import 'runewords_screen.dart';
import 'items_screen.dart';
import '../utils/app_colors.dart';
import 'sets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildMenuButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Reemplazado withOpacity por withValues
          backgroundColor: AppColors.panel.withValues(alpha: 0.8), 
          padding: const EdgeInsets.all(20.0),
          side: const BorderSide(color: AppColors.uniqueGold, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
        },
        child: Text(
          title, 
          style: const TextStyle(fontSize: 16, color: AppColors.uniqueGold, fontWeight: FontWeight.bold, letterSpacing: 1.2)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D2R COMPANION', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          children: [
            _buildMenuButton(context, 'CLASS BUILDS', const BuildsScreen()),
            _buildMenuButton(context, 'RUNE CALCULATOR', const CalculatorScreen()),
            _buildMenuButton(context, 'RUNEWORDS CATALOG', const RunewordsScreen()),
            // Tu ItemScreen ya es tu Holy Grail tracker oficial
            _buildMenuButton(context, 'HOLY GRAIL (UNIQUES)', const ItemsScreen()),
            _buildMenuButton(context, 'SET ITEMS DATABASE', const SetsScreen()),
          ],
        ),
      ),
    );
  }
}