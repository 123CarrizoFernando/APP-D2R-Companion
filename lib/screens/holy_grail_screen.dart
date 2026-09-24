import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class HolyGrailScreen extends StatefulWidget {
  const HolyGrailScreen({super.key});

  @override
  State<HolyGrailScreen> createState() => _HolyGrailScreenState();
}

class _HolyGrailScreenState extends State<HolyGrailScreen> {
  final ApiService _apiService = ApiService();
  
  List<dynamic> _allUniques = [];
  List<dynamic> _filteredItems = [];
  List<String> _foundItems = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // 1. Cargamos la memoria del teléfono
      final prefs = await SharedPreferences.getInstance();
      final savedGrail = prefs.getStringList('holy_grail') ?? [];

      // 2. Traemos todos los ítems únicos de la base de datos
      final uniques = await _apiService.getUniqueItems();

      setState(() {
        _foundItems = savedGrail;
        _allUniques = uniques;
        _filteredItems = uniques;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading Holy Grail: $e');
      setState(() => _isLoading = false);
    }
  }

  // Guardar el progreso en el teléfono (se sincroniza con las Builds automáticamente)
  Future<void> _toggleItem(String itemName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_foundItems.contains(itemName)) {
        _foundItems.remove(itemName);
      } else {
        _foundItems.add(itemName);
      }
      prefs.setStringList('holy_grail', _foundItems);
    });
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() => _filteredItems = _allUniques);
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredItems = _allUniques.where((item) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        final type = item['item_type']?.toString().toLowerCase() ?? '';
        return name.contains(lowerQuery) || type.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos el porcentaje de progreso
    final totalItems = _allUniques.length;
    final foundCount = _allUniques.where((item) => _foundItems.contains(item['name'])).length;
    final progress = totalItems == 0 ? 0.0 : foundCount / totalItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HOLY GRAIL TRACKER', style: TextStyle(letterSpacing: 1.5)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), // Espacio para buscador y barra de progreso
          child: Column(
            children: [
              // Barra de Progreso Visual
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('COLLECTION PROGRESS', style: TextStyle(color: AppColors.uniqueGold, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('$foundCount / $totalItems', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black45,
                      color: AppColors.uniqueGold,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              // Buscador
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: _filterItems,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search item or type (e.g., Ring, Sword)...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: AppColors.uniqueGold),
                    filled: true,
                    fillColor: Colors.black45,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.uniqueGold))
          : _filteredItems.isEmpty
              ? const Center(child: Text('No items match your search.', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    final name = item['name'] ?? 'Unknown';
                    final type = item['item_type'] ?? 'Item';
                    final isFound = _foundItems.contains(name);

                    return Card(
                      color: AppColors.panel,
                      margin: const EdgeInsets.only(bottom: 6.0),
                      child: ListTile(
                        onTap: () => _toggleItem(name),
                        leading: Icon(
                          isFound ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isFound ? Colors.green : Colors.white30,
                          size: 28,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            color: AppColors.uniqueGold,
                            fontWeight: FontWeight.bold,
                            decoration: isFound ? TextDecoration.lineThrough : TextDecoration.none,
                            decorationColor: AppColors.uniqueGold.withValues(alpha: 0.5),
                          ),
                        ),
                        subtitle: Text(type, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                    );
                  },
                ),
    );
  }
}