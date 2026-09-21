import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'runes_screen.dart'; // Agregamos el import de la nueva pantalla
import 'runewords_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'D2R COMPANION', 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0)
        ),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _buildMenuCard(context, '🧙 Builds', AppColors.uniqueGold, null),
          _buildMenuCard(context, '🔥 Runewords', AppColors.runeOrange, const RunewordsScreen()),
          _buildMenuCard(context, '🛡️ Bases', AppColors.textNormal, null),
          _buildMenuCard(context, '💎 Runes', AppColors.runeOrange, const RunesScreen()),
          _buildMenuCard(context, '⚔️ Items', AppColors.uniqueGold, null),
          _buildMenuCard(context, '👹 Mercenarios', AppColors.textNormal, null),
        ],
      ),
    );
  }

  // Agregamos un parámetro 'Widget? destination'
  Widget _buildMenuCard(BuildContext context, String title, Color color, Widget? destination) {
    return Card(
      color: AppColors.panel,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (destination != null) {
            // Si hay un destino, navegamos a esa pantalla
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          } else {
            // Si no, mostramos el cartel de "Cargando"
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Cargando $title...'),
                backgroundColor: AppColors.panel,
              ),
            );
          }
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}