import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rune.dart';
import '../models/runeword.dart'; 

class ApiService {
  // Reemplaza esto con la URL real de tu API en Render
   static const String baseUrl = 'http://localhost:3000/api';

  Future<List<Rune>> getRunes() async {
    try {
      // Nota cómo llamamos a ApiService.baseUrl
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
      // Nota cómo llamamos a ApiService.baseUrl aquí también
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
}