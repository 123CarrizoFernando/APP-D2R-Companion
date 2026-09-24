import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rune.dart';

class ApiService {
  static const String baseUrl = 'https://api-d2r-companion.onrender.com/api'; 

  Future<List<Rune>> getRunes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/runes'));
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
      final response = await http.get(Uri.parse('$baseUrl/runewords'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      } else {
        throw Exception('Fallo al cargar las palabras rúnicas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<dynamic>> getUniqueItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items/uniques'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      } else {
        throw Exception('Fallo al cargar los items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<dynamic>> getBuilds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/builds'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      } else {
        throw Exception('Fallo al cargar las builds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<dynamic>> getSets() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/sets'));
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