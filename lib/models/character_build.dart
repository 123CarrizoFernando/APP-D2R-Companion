class BuildEquipment {
  final String slot;
  final bool isAlternative;
  final String? uniqueItemName;
  final String? runewordName;

  BuildEquipment({
    required this.slot,
    required this.isAlternative,
    this.uniqueItemName,
    this.runewordName,
  });

  factory BuildEquipment.fromJson(Map<String, dynamic> json) {
    return BuildEquipment(
      slot: json['slot'] as String,
      isAlternative: json['is_alternative'] as bool? ?? false,
      uniqueItemName: json['unique_item_name'] as String?,
      runewordName: json['runeword_name'] as String?,
    );
  }
}

class CharacterBuild {
  final int id;
  final String characterClass;
  final String name;
  final String? tier;
  final String? budgetLevel;
  final String? description;
  final List<BuildEquipment> equipment;

  CharacterBuild({
    required this.id,
    required this.characterClass,
    required this.name,
    this.tier,
    this.budgetLevel,
    this.description,
    required this.equipment,
  });

  factory CharacterBuild.fromJson(Map<String, dynamic> json) {
    return CharacterBuild(
      id: json['id'] as int,
      characterClass: json['character_class'] as String,
      name: json['name'] as String,
      tier: json['tier'] as String?,
      budgetLevel: json['budget_level'] as String?,
      description: json['description'] as String?,
      equipment: json['equipment'] != null
          ? (json['equipment'] as List).map((e) => BuildEquipment.fromJson(e)).toList()
          : [],
    );
  }
}