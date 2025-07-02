import 'dart:convert';
import 'package:http/http.dart' as http;

class TiempoService {
  //static const _baseUrl = 'http://192.168.1.38:8000';
  static const String _baseUrl = 'https://tallerevalhta-913203481005.europe-west1.run.app';
  static const String _endpoint = 'tiempos_inferencia';

  static Future<Map<String, double>> obtenerTiempos() async {
    final url = Uri.parse('$_baseUrl/$_endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((modelo, tiempo) {
        return MapEntry(modelo, (tiempo as num).toDouble());
      });
    } else {
      throw Exception('Error al obtener tiempos de inferencia');
    }
  }
}
