import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class SetsScreen extends StatefulWidget {
  const SetsScreen({super.key});

  @override
  State<SetsScreen> createState() => _SetsScreenState();
}

class _SetsScreenState extends State<SetsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _setsFuture;

  @override
  void initState() {
    super.initState();
    // Asumimos que tienes un método getSets() en tu ApiService que hace un GET a /api/sets
    _setsFuture = _apiService.getSets(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ITEM SETS')),
      body: FutureBuilder<List<dynamic>>(
        future: _setsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sets found.', style: TextStyle(color: Colors.white)));
          }

          final sets = snapshot.data!;
          return ListView.builder(
            itemCount: sets.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final setItem = sets[index];
              final pieces = setItem['pieces'] as List<dynamic>;
              
              return Card(
                color: AppColors.panel,
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ExpansionTile(
                  title: Text(setItem['name'], style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('${pieces.length} Pieces', style: const TextStyle(color: Colors.white54)),
                  iconColor: Colors.green,
                  collapsedIconColor: Colors.green,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.black45,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SET PIECES', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...pieces.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text('• ${p['name']} (${p['base']})', style: const TextStyle(color: AppColors.textNormal)),
                          )),
                          const Divider(color: Colors.white24, height: 24),
                          const Text('FULL SET BONUSES', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(setItem['full_bonuses'].toString(), style: const TextStyle(color: AppColors.magicBlue)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}