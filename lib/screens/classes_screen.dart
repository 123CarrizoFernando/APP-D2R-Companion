import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';
import 'build_detail_screen.dart'; // La crearemos en el siguiente paso

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final List<String> _classes = [
    'Amazon', 'Assassin', 'Barbarian', 'Druid', 'Necromancer', 'Paladin', 'Sorceress'
  ];
  
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _allBuildsFuture;

  @override
  void initState() {
    super.initState();
    _allBuildsFuture = _apiService.getBuilds(); // Obtiene todas las builds
  }

  void _showClassBuilds(BuildContext context, String className, List<dynamic> allBuilds) {
    final classBuilds = allBuilds.where((b) => b['character_class'] == className).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('$className Builds'.toUpperCase())),
          body: ListView.builder(
            itemCount: classBuilds.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final build = classBuilds[index];
              return Card(
                color: AppColors.panel,
                child: ListTile(
                  title: Text(build['name'], style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                  subtitle: Text('Tier: ${build['tier']} | Budget: ${build['budget_level']}'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BuildDetailScreen(buildData: build),
                    ));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SELECT CLASS')),
      body: FutureBuilder<List<dynamic>>(
        future: _allBuildsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold));
          if (!snapshot.hasData) return const Center(child: Text('No data'));

          return ListView.builder(
            itemCount: _classes.length,
            itemBuilder: (context, index) {
              final className = _classes[index];
              return InkWell(
                onTap: () => _showClassBuilds(context, className, snapshot.data!),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    className.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2.0),
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