import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rune.dart';
import '../models/runeword.dart';
import '../models/unique_item.dart';
import '../models/character_build.dart'; // Importación de tu nuevo modelo

class ApiService {
  // Asegúrate de usar la URL que corresponda (localhost o Render)
  static const String baseUrl = 'https://tu-url-de-render.onrender.com/api'; 

  Future<List<Rune>> getRunes() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/runes'));

      if (response.statusCode == 200) {
        List<dynamic> decodedList = jsonDecode(response.body);
        return decodedList.map((json) => Rune.fromJson(json)).toList();
      } else {
        throw Exception('Fallo al cargar las runas desde la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<Runeword>> getRunewords() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/runewords'));

      if (response.statusCode == 200) {
        List<dynamic> decodedList = jsonDecode(response.body);
        return decodedList.map((json) => Runeword.fromJson(json)).toList();
      } else {
        throw Exception('Fallo al cargar las palabras rúnicas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<UniqueItem>> getUniqueItems() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/items/uniques'));

      if (response.statusCode == 200) {
        List<dynamic> decodedList = jsonDecode(response.body);
        return decodedList.map((json) => UniqueItem.fromJson(json)).toList();
      } else {
        throw Exception('Fallo al cargar los items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // Aquí está el método getBuilds correctamente ubicado dentro de la clase
  Future<List<CharacterBuild>> getBuilds() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/builds'));

      if (response.statusCode == 200) {
        List<dynamic> decodedList = jsonDecode(response.body);
        return decodedList.map((json) => CharacterBuild.fromJson(json)).toList();
      } else {
        throw Exception('Fallo al cargar las builds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}