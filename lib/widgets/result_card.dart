import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String modelo;
  final double probabilidad;
  final String riesgo;

  const ResultCard({
    super.key,
    required this.modelo,
    required this.probabilidad,
    required this.riesgo,
  });

  Color _getRiskColor(String riesgo) {
    switch (riesgo.toLowerCase()) {
      case 'alto':
        return Colors.red.shade700;
      case 'moderado':
        return Colors.amber.shade800;
      case 'bajo':
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.black, // Asegura que el fondo siga siendo blanco
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Modelo utilizado: $modelo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // <- Color oscuro explícito
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Probabilidad: ${probabilidad.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black, // <- Color oscuro explícito
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Riesgo: $riesgo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getRiskColor(riesgo), // ya era dependiente del riesgo
              ),
            ),
          ],
        ),
      ),
    );
  }
}
