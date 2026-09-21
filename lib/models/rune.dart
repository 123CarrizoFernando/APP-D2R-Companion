class Rune {
  final int id;
  final String name;
  final int levelRequired;

  Rune({
    required this.id,
    required this.name,
    required this.levelRequired,
  });

  factory Rune.fromJson(Map<String, dynamic> json) {
    return Rune(
      id: json['id'] as int,
      name: json['name'] as String,
      levelRequired: json['level_required'] as int,
    );
  }
}