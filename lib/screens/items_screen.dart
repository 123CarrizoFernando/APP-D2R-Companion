import 'package:flutter/material.dart';
import '../models/unique_item.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<UniqueItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _apiService.getUniqueItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UNIQUE ITEMS', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<UniqueItem>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron items únicos.', style: TextStyle(color: AppColors.textNormal)));
          }

          final items = snapshot.data!;
          
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                color: AppColors.panel,
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Required Level: ${item.levelRequired}',
                        style: const TextStyle(color: AppColors.textNormal, fontSize: 13),
                      ),
                      if (item.isEtherealPossible)
                        const Text(
                          '(Ethereal Available)',
                          style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      const Divider(color: Colors.white24, height: 20),
                      // Iteramos sobre las stats del JSON
                      ...item.attributes.entries.map((stat) {
                        String statName = stat.key.replaceAll('_', ' ').toUpperCase();
                        String statValue = stat.value.toString();
                        
                        // Si el valor es una lista (un rango como [20, 30]), lo formateamos con un guion
                        if (stat.value is List) {
                          statValue = '${stat.value[0]} - ${stat.value[1]}';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            '$statName: $statValue',
                            style: const TextStyle(color: AppColors.magicBlue, fontSize: 14),
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