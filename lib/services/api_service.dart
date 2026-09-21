import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/rune.dart';

class ApiService {
  // Para probar en el emulador de Android hacia tu PC local, usa 10.0.2.2
  // Si usas navegador/iOS, usa 127.0.0.1
  static const String baseUrl = 'https://d2r-companion.onrender.com'; 

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
}