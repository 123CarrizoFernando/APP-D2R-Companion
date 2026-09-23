import 'package:flutter/material.dart';
import '../models/rune.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final ApiService _apiService = ApiService();
  
  List<Rune> _allRunes = [];
  // Ahora usamos List<dynamic> para coincidir con la API actualizada
  List<dynamic> _allRunewords = []; 
  final Set<String> _ownedRunes = {};
  
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final runes = await _apiService.getRunes();
      final runewords = await _apiService.getRunewords();
      setState(() {
        _allRunes = runes;
        _allRunewords = runewords;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Lógica actualizada: Lee las runas desde el String del JSON (ej: "Tal + Thul + Ort + Amn")
  bool _canCraft(dynamic rw) {
    final runesString = rw['runes']?.toString() ?? '';
    if (runesString.isEmpty) return false;
    
    // Separamos el string por los signos '+' y limpiamos los espacios
    List<String> requiredRunes = runesString.split('+').map((e) => e.trim()).toList();
    List<String> tempInventory = _ownedRunes.toList();
    
    for (var runeName in requiredRunes) {
      if (tempInventory.contains(runeName)) {
        // En una app más compleja restaríamos la cantidad, aquí asumimos cantidad ilimitada 
        // del tipo de runa seleccionada para mantener la interfaz limpia.
      } else {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.runeOrange)),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red))),
      );
    }

    final craftableRunewords = _allRunewords.where((rw) => _canCraft(rw)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNE CALCULATOR', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Panel Superior: Selección de Runas
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.black45,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MY RUNES (Tap to toggle):', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: _allRunes.map((rune) {
                        final isSelected = _ownedRunes.contains(rune.name);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected ? _ownedRunes.remove(rune.name) : _ownedRunes.add(rune.name);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              // Reemplazamos withOpacity por withValues para evitar el deprecation warning
                              color: isSelected ? AppColors.runeOrange.withValues(alpha: 0.3) : AppColors.panel,
                              border: Border.all(color: isSelected ? AppColors.runeOrange : Colors.white24),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              rune.name,
                              style: TextStyle(
                                color: isSelected ? AppColors.runeOrange : AppColors.textNormal,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Panel Inferior: Resultados
          Expanded(
            child: Container(
              color: Colors.black,
              child: craftableRunewords.isEmpty
                  ? const Center(child: Text('Select more runes to discover recipes.', style: TextStyle(color: Colors.white38)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: craftableRunewords.length,
                      itemBuilder: (context, index) {
                        final rw = craftableRunewords[index];
                        final name = rw['name'] ?? 'Unknown';
                        final recipe = rw['runes'] ?? '';
                        final level = rw['level_requirement'] ?? '--';
                        final bases = rw['allowed_bases'] ?? 'Any';

                        return Card(
                          color: AppColors.panel,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(name, style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                            subtitle: Text('Bases: $bases | Level: $level\n$recipe', style: const TextStyle(color: AppColors.magicBlue)),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}