import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'home_screen.dart'; // Import para navegar a HomeScreen

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> factors;
  final String modelKey;

  const ResultScreen({
    Key? key,
    required this.factors,
    required this.modelKey,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Future<Map<String, dynamic>> _futureResultado;

  @override
  void initState() {
    super.initState();
    _futureResultado = ApiService.predecirHTA(widget.factors, widget.modelKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del Modelo'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureResultado,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al predecir: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se recibió resultado'));
          }

          final resultado = snapshot.data!;
          final String modelo = resultado['model'] ?? 'Desconocido';
          final double prob = (resultado['probability'] is num
              ? (resultado['probability'] as num).toDouble()
              : double.tryParse(resultado['probability'].toString()) ?? 0.0);
          final String riesgo = resultado['risk'] ?? 'No determinado';

          Color riesgoColor;
          switch (riesgo.toLowerCase()) {
            case 'alto':
              riesgoColor = Colors.red.shade700;
              break;
            case 'moderado':
              riesgoColor = Colors.orange.shade700;
              break;
            case 'bajo':
              riesgoColor = Colors.green.shade700;
              break;
            default:
              riesgoColor = Colors.grey;
          }

          return Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Modelo: $modelo',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Probabilidad: ${prob.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Riesgo: $riesgo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: riesgoColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('Probar otro Modelo'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Volver al Inicio',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





