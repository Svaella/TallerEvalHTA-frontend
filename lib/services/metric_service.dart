import 'dart:convert';
import 'package:http/http.dart' as http;

/// Modelo que almacena las métricas de un algoritmo de ML.
class ModelMetrics {
  final String displayName;
  final double accuracy;
  final double precision;
  final double recall;
  final double f1Score;

  ModelMetrics({
    required this.displayName,
    required this.accuracy,
    required this.precision,
    required this.recall,
    required this.f1Score,
  });
}

/// Servicio para obtener las métricas de cada modelo desde el backend.
class MetricService {
  /// Llama a GET /metricas y devuelve un Map<modelKey, ModelMetrics>.
  static Future<Map<String, ModelMetrics>> obtenerMetricas() async {
    //final url = Uri.parse('http://192.168.1.38:8000/metricas');
    final url = Uri.parse('https://tallerevalhta-913203481005.europe-west1.run.app/metricas');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al obtener métricas: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data.map((modelKey, rawMetrics) {
      final m = rawMetrics as Map<String, dynamic>;
      return MapEntry(
        modelKey,
        ModelMetrics(
          displayName: _prettyName(modelKey),
          accuracy: (m['accuracy'] as num).toDouble(),
          precision: (m['precision'] as num).toDouble(),
          recall: (m['recall'] as num).toDouble(),
          // adaptarse a 'f1_score' o 'f1Score'
          f1Score: (m['f1_score'] ?? m['f1Score'] as num).toDouble(),
        ),
      );
    });
  }

  /// Convierte la clave interna en un nombre legible (e.g. 'random_forest' → 'Random Forest').
  static String _prettyName(String key) {
    return key
        .split('_')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}