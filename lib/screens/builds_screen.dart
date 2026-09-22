import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import 'build_detail_screen.dart'; // Asegúrate de que esta importación sea correcta

class BuildsScreen extends StatefulWidget {
  const BuildsScreen({super.key});

  @override
  State<BuildsScreen> createState() => _BuildsScreenState();
}

class _BuildsScreenState extends State<BuildsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _buildsFuture;

  @override
  void initState() {
    super.initState();
    _buildsFuture = _apiService.getBuilds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLASS BUILDS'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _buildsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No builds found.', style: TextStyle(color: Colors.white)));
          }

          final builds = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: builds.length,
            itemBuilder: (context, index) {
              final build = builds[index];
              final equipment = build['equipment'] as List<dynamic>? ?? [];

              return Card(
                color: const Color(0xFF1E1E1E), // Color de fondo oscuro de la tarjeta
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                // AQUÍ ESTÁ LA MAGIA: InkWell envuelve el contenido de la tarjeta para detectar el toque
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuildDetailScreen(buildData: build),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado: Nombre de la Build y Tier
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${build['character_class']} - ${build['name']}',
                                style: const TextStyle(
                                  color: AppColors.uniqueGold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade800,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Tier ${build['tier']}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Budget: ${build['budget_level']}',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Divider(color: Colors.white24, height: 24),

                        // Sección de Equipamiento
                        const Text(
                          'RECOMMENDED GEAR:',
                          style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 8),

                        ...equipment.map((item) {
                          final itemName = item['unique_item_name'];
                          final runewordName = item['runeword_name'];
                          final displayName = itemName ?? runewordName ?? 'Rare/Crafted';
                          final isAlternative = item['is_alternative'] == true;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    '${item['slot']}:',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    isAlternative ? '$displayName (Budget)' : displayName,
                                    style: TextStyle(
                                      // Si es alternativo, lo pone gris y cursiva. Si es el principal, dorado y normal.
                                      color: isAlternative ? Colors.white54 : AppColors.uniqueGold,
                                      fontStyle: isAlternative ? FontStyle.italic : FontStyle.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
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