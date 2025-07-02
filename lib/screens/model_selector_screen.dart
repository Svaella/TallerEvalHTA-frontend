import 'package:flutter/material.dart';
import 'package:hta_evalmodel_ui/services/metric_service.dart';
import 'package:hta_evalmodel_ui/screens/result_screen.dart';

class ModelSelectorScreen extends StatelessWidget {
  final Map<String, dynamic> factors;
  const ModelSelectorScreen({
    Key? key,
    required this.factors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona un modelo')),
      body: FutureBuilder<Map<String, ModelMetrics>>(
        future: MetricService.obtenerMetricas(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar métricas: ${snapshot.error}'));
          }
          final metricsMap = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: metricsMap.length,
            itemBuilder: (_, index) {
              final entry = metricsMap.entries.elementAt(index);
              final modelKey = entry.key;
              final m = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(m.displayName),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => _showMetrics(context, m),
                  ),
                  onTap: () => _goToResult(context, factors, modelKey),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showMetrics(BuildContext ctx, ModelMetrics m) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              m.displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text('Accuracy: ${m.accuracy.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
            Text('Precision: ${m.precision.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
            Text('Recall: ${m.recall.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
            Text('F1-Score: ${m.f1Score.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _goToResult(BuildContext context, Map<String, dynamic> factors, String modelKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          factors: factors,
          modelKey: modelKey,
        ),
      ),
    );
  }
}