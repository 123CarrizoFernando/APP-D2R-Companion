import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BuildDetailScreen extends StatelessWidget {
  final dynamic buildData;

  const BuildDetailScreen({super.key, required this.buildData});

  // Función auxiliar para sugerir dónde buscar un ítem basado en mecánicas reales del juego
  String _getDropLocationHint(String? itemName, String? runewordName) {
    if (runewordName != null) return 'Farm Runes in: The Countess (Hell), Lower Kurast Chests, Hellforge.';
    if (itemName != null) {
      if (itemName == 'Harlequin Crest' || itemName == 'The Oculus') return 'Best Drops: Mephisto (Hell), Andariel (Hell).';
      if (itemName == 'Arachnid Mesh' || itemName == 'Griffon\'s Eye') return 'Best Drops: Diablo, Baal, Level 85 Areas (The Pit, Ancient Tunnels).';
      return 'Best Drops: Hell Bosses (Mephisto, Diablo, Baal) and Level 85 Areas.';
    }
    return 'Any Hell difficulty area.';
  }

  @override
  Widget build(BuildContext context) {
    final equipment = buildData['equipment'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(buildData['name'].toUpperCase())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección: Cómo Jugar
            const Text('PLAYSTYLE & STRATEGY', style: TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
              child: Text(
                buildData['description'] ?? 'No description available for this build.',
                style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
              ),
            ),
            const SizedBox(height: 24),

            // Sección: Equipamiento y Drops
            const Text('REQUIRED GEAR & DROP LOCATIONS', style: TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...equipment.map((item) {
              final itemName = item['unique_item_name'];
              final runewordName = item['runeword_name'];
              final displayName = itemName ?? runewordName ?? 'Rare/Crafted Item';
              final isRuneword = runewordName != null;

              return Card(
                color: AppColors.panel,
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['slot'].toString().toUpperCase(), style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                          if (item['is_alternative'] == true) 
                            const Text('ALTERNATIVE', style: TextStyle(color: Colors.orange, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayName,
                        style: TextStyle(
                          color: isRuneword ? AppColors.runeOrange : AppColors.uniqueGold,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(color: Colors.white24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on, color: Colors.white54, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _getDropLocationHint(itemName, runewordName),
                              style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}