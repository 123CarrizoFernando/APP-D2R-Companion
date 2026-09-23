import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rune.dart';
import '../models/unique_item.dart';

class ApiService {
  // Asegúrate de usar la URL que corresponda (localhost o Render)
  static const String baseUrl = 'https://api-d2r-companion.onrender.com/api'; 
  
  // ... resto de tu código ...
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

Future<List<dynamic>> getRunewords() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/runewords'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retorna la lista cruda para usarla en la UI
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

  // Corregido: Ahora devuelve List<dynamic> con el JSON directo para que funcione con tu UI
  Future<List<dynamic>> getBuilds() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/builds'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Retorna la lista cruda sin mapear
      } else {
        throw Exception('Fallo al cargar las builds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // Corregido: Se ajustó la ruta para evitar el doble "/api/api"
  Future<List<dynamic>> getSets() async {
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/sets'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al cargar los sets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }
}