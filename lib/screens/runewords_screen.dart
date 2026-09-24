import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class RunewordsScreen extends StatefulWidget {
  const RunewordsScreen({super.key});

  @override
  State<RunewordsScreen> createState() => _RunewordsScreenState();
}

class _RunewordsScreenState extends State<RunewordsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _allRunewords = [];
  List<dynamic> _filteredRunewords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _apiService.getRunewords();
      setState(() {
        _allRunewords = data;
        _filteredRunewords = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading runewords: $e');
    }
  }

  void _filterRunewords(String query) {
    if (query.isEmpty) {
      setState(() => _filteredRunewords = _allRunewords);
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredRunewords = _allRunewords.where((rw) {
        final name = rw['name']?.toString().toLowerCase() ?? '';
        
        // Manejo seguro para allowed_bases si es una lista
        final basesData = rw['allowed_bases'];
        final bases = basesData is List ? basesData.join(' ').toLowerCase() : basesData?.toString().toLowerCase() ?? '';
        
        return name.contains(lowerQuery) || bases.contains(lowerQuery);
      }).toList();
    });
  }

  String _formatAttributes(Map<String, dynamic>? attrs) {
    if (attrs == null || attrs.isEmpty) return 'Stats not available.';
    return attrs.entries.map((e) {
      final key = e.key.replaceAll('_', ' ').toUpperCase();
      return '+${e.value} $key';
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RUNEWORDS CATALOG'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterRunewords,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or base (e.g., Sword, Shield)...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: AppColors.uniqueGold),
                filled: true,
                fillColor: Colors.black45,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.runeOrange))
          : _filteredRunewords.isEmpty
              ? const Center(child: Text('No runewords found.', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _filteredRunewords.length,
                  itemBuilder: (context, index) {
                    final rw = _filteredRunewords[index];
                    final name = rw['name'] ?? 'Unknown';
                    final level = rw['level_requirement'] ?? '--';
                    
                    // Manejo seguro de listas (Convierte ["Tal", "Thul"] en "Tal + Thul")
                    final runesData = rw['runes'];
                    final runes = runesData is List ? runesData.join(' + ') : runesData?.toString() ?? '';
                    
                    final basesData = rw['allowed_bases'];
                    final bases = basesData is List ? basesData.join(', ') : basesData?.toString() ?? 'Any';
                    
                    final attributes = rw['attributes'];

                    return Card(
                      color: AppColors.panel,
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.runeOrange.withValues(alpha: 0.3), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        iconColor: AppColors.runeOrange,
                        collapsedIconColor: Colors.white54,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Lvl $level',
                              style: const TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                runes,
                                style: const TextStyle(color: AppColors.runeOrange, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bases,
                                style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.black45,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _formatAttributes(attributes),
                              style: const TextStyle(color: AppColors.magicBlue, fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}