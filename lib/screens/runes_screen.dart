import 'package:flutter/material.dart';
import '../models/rune.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class RunesScreen extends StatefulWidget {
  const RunesScreen({super.key});

  @override
  State<RunesScreen> createState() => _RunesScreenState();
}

class _RunesScreenState extends State<RunesScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Rune>> _runesFuture;

  @override
  void initState() {
    super.initState();
    _runesFuture = _apiService.getRunes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNES', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Rune>>(
        future: _runesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.runeOrange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron runas.', style: TextStyle(color: AppColors.textNormal)));
          }

          final runes = snapshot.data!;
          
          return ListView.builder(
            itemCount: runes.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final rune = runes[index];
              return Card(
                color: AppColors.panel,
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.background,
                    child: Text(
                      '${rune.id}', 
                      style: const TextStyle(color: AppColors.textNormal, fontSize: 12)
                    ),
                  ),
                  title: Text(
                    '${rune.name} Rune',
                    style: const TextStyle(color: AppColors.runeOrange, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  trailing: Text(
                    'Lvl ${rune.levelRequired}',
                    style: const TextStyle(color: AppColors.textNormal),
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