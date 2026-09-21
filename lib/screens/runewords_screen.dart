import 'package:flutter/material.dart';
import '../models/runeword.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class RunewordsScreen extends StatefulWidget {
  const RunewordsScreen({super.key});

  @override
  State<RunewordsScreen> createState() => _RunewordsScreenState();
}

class _RunewordsScreenState extends State<RunewordsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Runeword>> _runewordsFuture;

  @override
  void initState() {
    super.initState();
    _runewordsFuture = _apiService.getRunewords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNEWORDS', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Runeword>>(
        future: _runewordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron palabras rúnicas.', style: TextStyle(color: AppColors.textNormal)));
          }

          final runewords = snapshot.data!;
          
          return ListView.builder(
            itemCount: runewords.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final rw = runewords[index];
              // Unimos los nombres de las runas en un String (Ej: Tal + Thul + Ort + Amn)
              final runeCombination = rw.runes?.map((r) => r.name).join(' + ') ?? '';

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
                            rw.name,
                            style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            'Lvl ${rw.levelRequired}',
                            style: const TextStyle(color: AppColors.textNormal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sockets: ${rw.socketsRequired}',
                        style: const TextStyle(color: AppColors.textNormal, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        runeCombination,
                        style: const TextStyle(color: AppColors.runeOrange, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(color: Colors.white24, height: 20),
                      // Iteramos sobre las llaves del JSONB para mostrar las stats
                      ...rw.attributes.entries.map((stat) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            '${stat.key.replaceAll('_', ' ').toUpperCase()}: ${stat.value}',
                            style: const TextStyle(color: AppColors.magicBlue, fontSize: 13),
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