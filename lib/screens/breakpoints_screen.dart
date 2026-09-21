import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BreakpointsScreen extends StatelessWidget {
  const BreakpointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BREAKPOINTS', style: TextStyle(letterSpacing: 2.0)),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppColors.uniqueGold,
            labelColor: AppColors.uniqueGold,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'FCR (Cast Rate)'),
              Tab(text: 'FHR (Hit Recovery)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFcrTab(),
            _buildFhrTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFcrTab() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildClassCard('Sorceress / Paladin', [0, 9, 20, 37, 63, 105, 200]),
        _buildClassCard('Necromancer / Paladin (Vampire)', [0, 9, 18, 30, 48, 75, 125]),
        _buildClassCard('Druid (Human)', [0, 4, 10, 19, 30, 46, 68, 99, 163]),
        _buildClassCard('Assassin', [0, 8, 16, 27, 42, 65, 102, 174]),
        _buildClassCard('Barbarian', [0, 9, 20, 37, 63, 105, 200]),
        _buildClassCard('Amazon', [0, 7, 14, 22, 32, 48, 68, 99, 152]),
      ],
    );
  }

  Widget _buildFhrTab() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildClassCard('Sorceress', [0, 5, 9, 14, 20, 30, 42, 60, 86, 142]),
        _buildClassCard('Paladin', [0, 7, 15, 27, 48, 86, 200]),
        _buildClassCard('Necromancer', [0, 5, 10, 16, 26, 39, 56, 86, 152]),
        _buildClassCard('Druid (Human)', [0, 3, 7, 13, 19, 29, 39, 56, 86, 152]),
        _buildClassCard('Assassin', [0, 7, 15, 27, 48, 86, 200]),
        _buildClassCard('Barbarian', [0, 7, 15, 27, 48, 86, 200]),
        _buildClassCard('Amazon', [0, 6, 13, 20, 32, 52, 86, 174]),
      ],
    );
  }

  Widget _buildClassCard(String className, List<int> frames) {
    return Card(
      color: AppColors.panel,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              className,
              style: const TextStyle(color: AppColors.uniqueGold, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(color: Colors.white24, height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(frames.length, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    border: Border.all(color: Colors.white10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text('${frames[index]}%', style: const TextStyle(color: AppColors.magicBlue, fontWeight: FontWeight.bold)),
                      Text('${15 - index}f', style: const TextStyle(color: Colors.white54, fontSize: 10)), // Frame base aproximado
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}