import 'rune.dart';

class Runeword {
  final int id;
  final String name;
  final int levelRequired;
  final int socketsRequired;
  final Map<String, dynamic> attributes;
  final List<Rune>? runes;

  Runeword({
    required this.id,
    required this.name,
    required this.levelRequired,
    required this.socketsRequired,
    required this.attributes,
    this.runes,
  });

  factory Runeword.fromJson(Map<String, dynamic> json) {
    return Runeword(
      id: json['id'] as int,
      name: json['name'] as String,
      levelRequired: json['level_required'] as int,
      socketsRequired: json['sockets_required'] as int,
      attributes: json['attributes'] as Map<String, dynamic>,
      runes: json['runes'] != null 
          ? (json['runes'] as List).map((r) => Rune.fromJson(r)).toList()
          : null,
    );
  }
}