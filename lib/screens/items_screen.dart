import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ApiService _apiService = ApiService();
  // Cambiado a List<dynamic> para coincidir con la API
  late Future<List<dynamic>> _itemsFuture; 
  
  final Set<String> _foundItems = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _itemsFuture = _apiService.getUniqueItems();
    _loadFoundItems();
  }

  Future<void> _loadFoundItems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedItems = prefs.getStringList('holy_grail_items');
    if (savedItems != null) {
      setState(() {
        _foundItems.addAll(savedItems);
      });
    }
  }

  Future<void> _toggleItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_foundItems.contains(itemId)) {
        _foundItems.remove(itemId);
      } else {
        _foundItems.add(itemId);
      }
    });
    await prefs.setStringList('holy_grail_items', _foundItems.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOLY GRAIL (UNIQUES)', style: TextStyle(letterSpacing: 2.0)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
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
          final progress = items.isEmpty ? 0.0 : _foundItems.length / items.length;

          final filteredItems = items.where((item) {
            final name = item['name']?.toString().toLowerCase() ?? '';
            return name.contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.black54,
                child: Row(
                  children: [
                    const Text('Progress:', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white12,
                        color: AppColors.uniqueGold,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${_foundItems.length}/${items.length}', style: const TextStyle(color: AppColors.textNormal)),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search items (e.g., Shako, Griffon...)',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: AppColors.uniqueGold),
                    filled: true,
                    fillColor: AppColors.panel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text('No items match your search.', style: TextStyle(color: Colors.white54)))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          // Leemos los valores del JSON usando corchetes
                          final itemId = item['id'].toString();
                          final itemName = item['name'] ?? 'Unknown';
                          final itemLevel = item['level_requirement'] ?? '--';
                          final Map<String, dynamic> attributes = item['attributes'] ?? {};
                          
                          final isFound = _foundItems.contains(itemId);

                          return GestureDetector(
                            onTap: () => _toggleItem(itemId),
                            child: Card(
                              color: isFound ? Colors.black45 : AppColors.panel,
                              margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  // Reemplazado withOpacity por withValues
                                  color: isFound ? Colors.green.withValues(alpha: 0.5) : Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (isFound) const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                        if (isFound) const SizedBox(width: 8),
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            // Reemplazado withOpacity por withValues
                                            color: isFound ? AppColors.uniqueGold.withValues(alpha: 0.6) : AppColors.uniqueGold, 
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 20,
                                            decoration: isFound ? TextDecoration.lineThrough : null,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Required Level: $itemLevel',
                                      style: const TextStyle(color: AppColors.textNormal, fontSize: 13),
                                    ),
                                    const Divider(color: Colors.white24, height: 20),
                                    ...attributes.entries.map((stat) {
                                      String statName = stat.key.replaceAll('_', ' ').toUpperCase();
                                      String statValue = stat.value.toString();
                                      if (stat.value is List) statValue = '${stat.value[0]} - ${stat.value[1]}';

                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 2.0),
                                        child: Text(
                                          '$statName: $statValue',
                                          style: TextStyle(
                                            // Reemplazado withOpacity por withValues
                                            color: isFound ? AppColors.magicBlue.withValues(alpha: 0.6) : AppColors.magicBlue, 
                                            fontSize: 14
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}