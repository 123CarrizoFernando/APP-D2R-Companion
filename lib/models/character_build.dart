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

class MercenarySetup {
  final String setupName;
  final String mercenaryType;
  final String? weapon;
  final String? helm;
  final String? armor;
  final String? justification;

  MercenarySetup({
    required this.setupName,
    required this.mercenaryType,
    this.weapon,
    this.helm,
    this.armor,
    this.justification,
  });

  factory MercenarySetup.fromJson(Map<String, dynamic> json) {
    return MercenarySetup(
      setupName: json['setup_name'] as String,
      mercenaryType: json['mercenary_type'] as String,
      weapon: json['weapon'] as String?,
      helm: json['helm'] as String?,
      armor: json['armor'] as String?,
      justification: json['justification'] as String?,
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
  final List<MercenarySetup> mercenaries; // Nueva lista agregada

  CharacterBuild({
    required this.id,
    required this.characterClass,
    required this.name,
    this.tier,
    this.budgetLevel,
    this.description,
    required this.equipment,
    required this.mercenaries,
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
      mercenaries: json['mercenaries'] != null
          ? (json['mercenaries'] as List).map((m) => MercenarySetup.fromJson(m)).toList()
          : [],
    );
  }
}