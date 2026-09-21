class UniqueItem {
  final int id;
  final String name;
  final int? itemTypeId;
  final int levelRequired;
  final bool isEtherealPossible;
  final Map<String, dynamic> attributes;

  UniqueItem({
    required this.id,
    required this.name,
    this.itemTypeId,
    required this.levelRequired,
    required this.isEtherealPossible,
    required this.attributes,
  });

  factory UniqueItem.fromJson(Map<String, dynamic> json) {
    return UniqueItem(
      id: json['id'] as int,
      name: json['name'] as String,
      itemTypeId: json['item_type_id'] as int?,
      levelRequired: json['level_required'] as int,
      isEtherealPossible: json['is_ethereal_possible'] as bool,
      attributes: json['attributes'] as Map<String, dynamic>,
    );
  }
}