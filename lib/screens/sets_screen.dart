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
  List<dynamic> _allSets = [];
  List<dynamic> _filteredSets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _apiService.getSets();
      
      // PRUEBA DE FUEGO: Esto imprimirá los datos crudos en tu consola de VS Code
      debugPrint("=== DATOS DE SETS RECIBIDOS DESDE RENDER ===");
      debugPrint(data.toString());
      debugPrint("==========================================");

      setState(() {
        _allSets = data;
        _filteredSets = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading sets: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filterSets(String query) {
    if (query.isEmpty) {
      setState(() => _filteredSets = _allSets);
      return;
    }
    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredSets = _allSets.where((setItem) {
        final name = setItem['name']?.toString().toLowerCase() ?? '';
        return name.contains(lowerQuery);
      }).toList();
    });
  }

  List<dynamic> _safeExtractList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map) return data.values.toList();
    return [data];
  }

  Widget _buildPieceCard(dynamic pieceData) {
    if (pieceData == null || pieceData is! Map) return const SizedBox.shrink();
    
    final Map<String, dynamic> piece = Map<String, dynamic>.from(pieceData);

    final nameEs = piece['name_es']?.toString() ?? piece['name']?.toString() ?? 'Nombre Desconocido';
    final nameEn = piece['name_en']?.toString() ?? '';
    
    final fallbackImage = piece['name']?.toString().toLowerCase().replaceAll(' ', '_').replaceAll('\'', '') ?? 'unknown';
    final imageName = piece['image_name']?.toString() ?? fallbackImage;
    
    final baseName = piece['base_name']?.toString() ?? piece['base_type']?.toString() ?? '';
    final tier = piece['tier']?.toString();
    final tc = piece['tc']?.toString();

    final type = piece['type']?.toString();
    final defense = piece['defense']?.toString();
    final durability = piece['durability']?.toString();
    final reqStr = piece['req_str']?.toString();
    final reqLvl = piece['req_lvl']?.toString();
    final classOnly = piece['class_only']?.toString();
    final version = piece['version']?.toString();
    
    final statsBlue = _safeExtractList(piece['stats_blue'] ?? piece['stats']);
    final statsGreen = _safeExtractList(piece['stats_green']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/items/$imageName.png',
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.white24, size: 40),
                ),
                const SizedBox(height: 8),
                Text(nameEs, style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                if (nameEn.isNotEmpty) Text(nameEn, style: const TextStyle(color: Colors.greenAccent, fontSize: 12), textAlign: TextAlign.center),
                if (baseName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(baseName, style: const TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
                ],
                if (tier != null) Text('[$tier]', style: const TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                if (tc != null) Text('TC:$tc', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type != null) Text('Tipo de Objetos: $type', style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (defense != null) Text('Defensa: $defense', style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (durability != null) Text('Durabilidad: $durability', style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (reqStr != null) Text('Fuerza: $reqStr', style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (reqLvl != null) Text('Nivel: $reqLvl', style: const TextStyle(color: Colors.white, fontSize: 12)),
                if (classOnly != null) Text('($classOnly)', style: const TextStyle(color: Colors.orange, fontSize: 12)),
                
                if (defense != null || durability != null || reqStr != null || reqLvl != null)
                  const SizedBox(height: 6),
                
                ...statsBlue.map((stat) => Text(stat.toString(), style: const TextStyle(color: AppColors.magicBlue, fontSize: 12))),
                
                if (statsGreen.isNotEmpty) const SizedBox(height: 6),
                
                ...statsGreen.map((stat) => Text(stat.toString(), style: const TextStyle(color: Colors.greenAccent, fontSize: 12))),
                
                if (version != null) ...[
                  const SizedBox(height: 6),
                  Text('($version)', style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SET ITEMS DATABASE', style: TextStyle(letterSpacing: 1.5)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterSets,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search set...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: AppColors.uniqueGold),
                filled: true,
                fillColor: Colors.black.withValues(alpha: 0.45),
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
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : _filteredSets.isEmpty
              ? const Center(child: Text('No sets found.', style: TextStyle(color: Colors.white54)))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  color: Colors.greenAccent,
                  backgroundColor: Colors.black,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(), // Necesario para que funcione el Refresh
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _filteredSets.length,
                    itemBuilder: (context, index) {
                      final setInfo = _filteredSets[index];
                      final name = setInfo['name']?.toString() ?? 'Unknown Set';
                      final partialBonuses = _safeExtractList(setInfo['partial_bonuses']);
                      final fullBonuses = _safeExtractList(setInfo['full_bonuses']);
                      final pieces = _safeExtractList(setInfo['pieces']);

                      return Card(
                        color: AppColors.panel.withValues(alpha: 0.9),
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ExpansionTile(
                          iconColor: Colors.greenAccent,
                          collapsedIconColor: Colors.white54,
                          title: Text(name, style: const TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                          children: [
                            Container(
                              width: double.infinity,
                              color: Colors.black.withValues(alpha: 0.5),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (pieces.isNotEmpty) ...[
                                    const Text('PIEZAS DEL SET:', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    ...pieces.map((piece) => _buildPieceCard(piece)),
                                    const SizedBox(height: 8),
                                  ],
                                  if (partialBonuses.isNotEmpty) ...[
                                    const Divider(color: Colors.white24, height: 24),
                                    const Text('BONOS PARCIALES DEL SET:', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    ...partialBonuses.map((b) => Text('• $b', style: const TextStyle(color: Colors.greenAccent, fontSize: 13))),
                                  ],
                                  if (fullBonuses.isNotEmpty) ...[
                                    const Divider(color: Colors.white24, height: 24),
                                    const Text('BONOS DEL SET COMPLETO:', style: TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    ...fullBonuses.map((b) => Text('• $b', style: const TextStyle(color: Colors.greenAccent, fontSize: 13))),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}