import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/metric_service.dart';

class ClassificationMetricsTab extends StatefulWidget {
  const ClassificationMetricsTab({super.key});

  @override
  State<ClassificationMetricsTab> createState() => _ClassificationMetricsTabState();
}

class _ClassificationMetricsTabState extends State<ClassificationMetricsTab> {
  late Map<String, ModelMetrics> _metricas;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarMetricas();
  }

  Future<void> _cargarMetricas() async {
    try {
      final data = await MetricService.obtenerMetricas();
      setState(() {
        _metricas = data;
        _cargando = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar métricas: $e')),
      );
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final metricDefs = <_MetricDef>[
      _MetricDef('Accuracy', (m) => m.accuracy),
      _MetricDef('Precision', (m) => m.precision),
      _MetricDef('Recall', (m) => m.recall),
      _MetricDef('F1-Score', (m) => m.f1Score),
    ];

    return _cargando
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ...metricDefs.map((def) => Column(
                      children: [
                        Text(def.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(height: 280, child: _buildBarChart(def)),
                        const SizedBox(height: 24),
                      ],
                    )),
                _buildLegend(),
              ],
            ),
          );
  }

  Widget _buildBarChart(_MetricDef def) {
    final modelos = _metricas.keys.toList();
    final colores = [
      Colors.blue, Colors.orange, Colors.green, Colors.brown,
      Colors.deepPurple, Colors.red, Colors.limeAccent, Colors.pinkAccent,
    ];

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 1,
        groupsSpace: 12,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: List.generate(modelos.length, (i) {
              final m = _metricas[modelos[i]]!;
              return BarChartRodData(
                toY: def.value(m),
                color: colores[i % colores.length],
                width: 24,
                borderRadius: BorderRadius.circular(2),
              );
            }),
          )
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.1,
              reservedSize: 32,
              getTitlesWidget: (value, _) => Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final colores = [
      Colors.blue, Colors.orange, Colors.green, Colors.brown,
      Colors.deepPurple, Colors.red, Colors.limeAccent, Colors.pinkAccent,
    ];
    final modelos = _metricas.keys.toList();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(modelos.length, (i) {
        final modelo = _metricas[modelos[i]]!;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 14, height: 14, color: colores[i % colores.length]),
            const SizedBox(width: 6),
            Text(modelo.displayName, style: const TextStyle(fontSize: 13)),
          ],
        );
      }),
    );
  }
}

class _MetricDef {
  final String label;
  final double Function(ModelMetrics) value;
  const _MetricDef(this.label, this.value);
}
