import 'package:flutter/material.dart';
import '../models/character_build.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class BuildsScreen extends StatefulWidget {
  const BuildsScreen({super.key});

  @override
  State<BuildsScreen> createState() => _BuildsScreenState();
}

class _BuildsScreenState extends State<BuildsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<CharacterBuild>> _buildsFuture;

  @override
  void initState() {
    super.initState();
    _buildsFuture = _apiService.getBuilds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLASS BUILDS', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CharacterBuild>>(
        future: _buildsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron builds.', style: TextStyle(color: AppColors.textNormal)));
          }

          final builds = snapshot.data!;
          
          return ListView.builder(
            itemCount: builds.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final build = builds[index];

              return Card(
                color: AppColors.panel,
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- CABECERA DE LA BUILD ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${build.characterClass} - ${build.name}',
                            style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          if (build.tier != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.red[900], borderRadius: BorderRadius.circular(4)),
                              child: Text('Tier ${build.tier}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Budget: ${build.budgetLevel ?? "N/A"}', style: const TextStyle(color: AppColors.textNormal)),
                      const Divider(color: Colors.white24, height: 20),
                      
                      // --- SECCIÓN DE EQUIPO PRINCIPAL ---
                      const Text('RECOMMENDED GEAR:', style: TextStyle(color: AppColors.runeOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      
                      ...build.equipment.map((eq) {
                        String itemName = eq.uniqueItemName ?? eq.runewordName ?? 'Unknown';
                        Color itemColor = eq.uniqueItemName != null ? AppColors.uniqueGold : AppColors.runeOrange;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text('${eq.slot}:', style: const TextStyle(color: AppColors.textNormal, fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Text(
                                  eq.isAlternative ? '$itemName (Budget)' : itemName,
                                  style: TextStyle(
                                    color: itemColor, 
                                    fontStyle: eq.isAlternative ? FontStyle.italic : FontStyle.normal
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // --- SECCIÓN DE MERCENARIOS ---
                      if (build.mercenaries.isNotEmpty) ...[
                        const Divider(color: Colors.white24, height: 30),
                        const Text('MERCENARY OPTIONS:', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        ...build.mercenaries.map((merc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${merc.setupName} (${merc.mercenaryType})', style: const TextStyle(color: AppColors.magicBlue, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                if (merc.weapon != null) Text('Weapon: ${merc.weapon}', style: const TextStyle(color: AppColors.textNormal, fontSize: 13)),
                                if (merc.helm != null) Text('Helm: ${merc.helm}', style: const TextStyle(color: AppColors.textNormal, fontSize: 13)),
                                if (merc.armor != null) Text('Armor: ${merc.armor}', style: const TextStyle(color: AppColors.textNormal, fontSize: 13)),
                                if (merc.justification != null) ...[
                                  const SizedBox(height: 6),
                                  Text(merc.justification!, style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic)),
                                ]
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}