import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  //static const _baseUrl = 'http://192.168.1.38:8000';
  static const _baseUrl = 'https://tallerevalhta-336670815560.europe-west1.run.app';

  static Future<Map<String, dynamic>> predecirHTA(
    Map<String, dynamic> factors,
    String modelKey,
  ) async {
    final url = Uri.parse('$_baseUrl/predict');

    for (final entry in factors.entries) {
      if (entry.value == "Seleccionar" || entry.value.toString().isEmpty) {
        throw Exception("Campo '${entry.key}' no fue completado correctamente.");
      }
    }

    final Map<String, dynamic> body = {
      'model': modelKey,
      'Age': _calcularEdadRango(int.parse(factors['Edad'])),
      'Sex': factors['Sexo'],
      'Peso': double.parse(factors['Peso']),
      'Altura': double.parse(factors['Altura']),
      'MentHlth': int.parse(factors['MentHlth']),
      'Sal': factors['Sal'],
      'Actividad': factors['Actividad'],
      'Fuma': factors['Fuma'],
      'Vapeo': factors['Vapeo'],
      'Alcohol30d': factors['Alcohol30d'],
      'Diabetes': factors['Diabetes'],
      'Colesterol': factors['Colesterol'],
    };

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (resp.statusCode != 200) {
      throw Exception('Error ${resp.statusCode}: ${resp.body}');
    }

    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  static int _calcularEdadRango(int edad) {
    if (edad <= 24) return 1;
    if (edad <= 29) return 2;
    if (edad <= 34) return 3;
    if (edad <= 39) return 4;
    if (edad <= 44) return 5;
    if (edad <= 49) return 6;
    if (edad <= 54) return 7;
    if (edad <= 59) return 8;
    if (edad <= 64) return 9;
    if (edad <= 69) return 10;
    if (edad <= 74) return 11;
    if (edad <= 79) return 12;
    return 13;
  }
}
