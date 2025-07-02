import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/roc_curve.dart';

class AucService {
  //static const _baseUrl = 'http://192.168.1.38:8000';
  static const String _baseUrl = 'https://tallerevalhta-913203481005.europe-west1.run.app';
  static const String _endpoint = 'auc_curvas'; // ✅ Ruta correcta

  static Future<Map<String, RocCurve>> obtenerCurvas() async {
    final url = Uri.parse('$_baseUrl/$_endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, RocCurve> curvas = {};

      data.forEach((modelo, curvaData) {
        curvas[modelo] = RocCurve.fromJson(curvaData);
      });

      return curvas;
    } else {
      throw Exception('Error al obtener curvas AUC: ${response.statusCode}');
    }
  }
}
