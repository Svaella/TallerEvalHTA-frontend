import 'dart:convert';
import 'package:http/http.dart' as http;

class LossRate {
  final double train;
  final double test;

  LossRate({required this.train, required this.test});
}

class LossService {
  //static const _baseUrl = 'http://192.168.1.38:8000';
  static const String _baseUrl = 'https://tallerevalhta-336670815560.europe-west1.run.app';
  static const String _endpoint = 'loss_rate';

  static Future<Map<String, LossRate>> obtenerLossRates() async {
    final url = Uri.parse('$_baseUrl/$_endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((modelo, valores) {
        return MapEntry(modelo, LossRate(
          train: (valores['train'] as num).toDouble(),
          test: (valores['test'] as num).toDouble(),
        ));
      });
    } else {
      throw Exception('Error al obtener tasas de pérdida');
    }
  }
}
