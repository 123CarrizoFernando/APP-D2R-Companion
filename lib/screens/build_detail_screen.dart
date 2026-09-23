import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';

class BuildDetailScreen extends StatefulWidget {
  final dynamic buildData;

  const BuildDetailScreen({super.key, required this.buildData});

  @override
  State<BuildDetailScreen> createState() => _BuildDetailScreenState();
}

class _BuildDetailScreenState extends State<BuildDetailScreen> {
  List<String> _foundItems = [];

  @override
  void initState() {
    super.initState();
    _loadHolyGrail();
  }

  Future<void> _loadHolyGrail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _foundItems = prefs.getStringList('holy_grail') ?? [];
    });
  }

  Future<void> _toggleHolyGrailItem(String itemName) async {
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

  String _getDropLocationHint(String? itemName, String? runewordName) {
    if (runewordName != null) return 'Farm Runes in: The Countess (Hell), Lower Kurast Chests, Hellforge.';
    if (itemName != null) {
      if (itemName == 'Harlequin Crest' || itemName == 'The Oculus') return 'Best Drops: Mephisto (Hell), Andariel (Hell).';
      if (itemName == 'Arachnid Mesh' || itemName == 'Griffon\'s Eye') return 'Best Drops: Diablo, Baal, Level 85 Areas.';
      return 'Best Drops: Hell Bosses (Mephisto, Diablo, Baal) and Level 85 Areas.';
    }
    return 'Any Hell difficulty area.';
  }

  String _formatAttributes(Map<String, dynamic>? attrs) {
    if (attrs == null || attrs.isEmpty) return 'Stats not available yet.';
    return attrs.entries.map((e) {
      final key = e.key.replaceAll('_', ' ').toUpperCase();
      return '+${e.value} $key';
    }).join('\n');
  }

  String _getImageName(String itemName) {
    return itemName.toLowerCase().replaceAll(' ', '_').replaceAll('\'', '');
  }

  Widget _buildItemCard(dynamic item) {
    final itemName = item['unique_item_name'];
    final runewordName = item['runeword_name'];
    
    if (itemName == null && runewordName == null) return const SizedBox.shrink();

    final displayName = itemName ?? runewordName;
    final isRuneword = runewordName != null;
    final isAlt = item['is_alternative'] == true;
    final attributesMap = isRuneword ? item['runeword_attributes'] : item['unique_attributes'];
    final imageAssetPath = 'assets/items/${_getImageName(displayName)}.png';
    final isFound = _foundItems.contains(displayName);

    return Card(
      color: AppColors.panel,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ExpansionTile(
        iconColor: AppColors.uniqueGold,
        collapsedIconColor: Colors.white54,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item['slot'].toString().toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
            if (isAlt) const Text('ALTERNATIVE', style: TextStyle(color: Colors.orange, fontSize: 10)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  color: isRuneword ? AppColors.runeOrange : AppColors.uniqueGold,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: isFound ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                isFound ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isFound ? Colors.green : Colors.white30,
              ),
              onPressed: () => _toggleHolyGrailItem(displayName),
            ),
          ],
        ),
        children: [
          Container(
            color: Colors.black45,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    imageAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.white24, size: 40),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white54, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _getDropLocationHint(itemName, runewordName),
                              style: const TextStyle(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 16),
                      Text(
                        _formatAttributes(attributesMap),
                        style: const TextStyle(color: AppColors.magicBlue, fontSize: 14, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final equipment = widget.buildData['equipment'] as List<dynamic>? ?? [];
    final merc = widget.buildData['mercenary'];
    final className = widget.buildData['character_class'].toString().toLowerCase();

    return Scaffold(
      // CustomScrollView reemplaza al SingleChildScrollView para permitir efectos Parallax
      body: CustomScrollView(
        slivers: [
          // CABECERA DEL PERSONAJE (Se encoge y mueve al scrollear)
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.buildData['name'].toUpperCase(), 
                style: const TextStyle(
                  color: Colors.white, 
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)]
                )
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/classes/$className.png', // ej. assets/classes/sorceress.png
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
                  ),
                  // Un degradado para que el texto sea legible
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // CONTENIDO PRINCIPAL DE LA BUILD
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PLAYSTYLE & STRATEGY', style: TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      widget.buildData['description'] ?? 'No description available.',
                      style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text('REQUIRED GEAR & HOLY GRAIL', style: TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  ...equipment.map((item) => _buildItemCard(item)),

                  const SizedBox(height: 24),

                  // SECCIÓN DEL MERCENARIO CON IMAGEN
                  if (merc != null) ...[
                    const Text('MERCENARY SETUP', style: TextStyle(color: AppColors.uniqueGold, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    
                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2E),
                        border: Border.all(color: Colors.blueGrey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del Mercenario
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/mercenaries/${merc['type'].toString().toLowerCase().replaceAll(' ', '_')}.png'), // ej. desert_mercenary.png
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Act ${merc['act']} ${merc['type']} - ${merc['aura']} Aura', style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(merc['justification'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    if (merc['gear'] != null)
                      ...(merc['gear'] as List<dynamic>).map((item) => _buildItemCard(item)),

                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}