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
                      const Text('RECOMMENDED GEAR:', style: TextStyle(color: AppColors.runeOrange, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      // Listar el equipo iterando sobre la lista de la base de datos
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