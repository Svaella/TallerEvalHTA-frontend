import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auc_service.dart';
import '../models/roc_curve.dart';

class AucCurvesTab extends StatefulWidget {
  const AucCurvesTab({Key? key}) : super(key: key);

  @override
  State<AucCurvesTab> createState() => _AucCurvesTabState();
}

class _AucCurvesTabState extends State<AucCurvesTab> {
  Map<String, RocCurve>? _curvas;
  bool _cargando = true;

  final Map<String, String> nombresBonitos = {
    'random_forest': 'Random Forest',
    'decision_tree': 'Decision Tree',
    'xgboost': 'XGBoost',
    'adaboost': 'Adaboost',
    'lightgbm': 'LightGBM',
    'catboost': 'CatBoost',
    'svm_rbf': 'SVM',
    'red_neuronal': 'Red Neuronal',
  };

  final Map<String, double> aucValores = {
    'random_forest': 0.9300,
    'decision_tree': 0.7558,
    'xgboost': 0.9200,
    'adaboost': 0.8210,
    'lightgbm': 0.8231,
    'catboost': 0.8248,
    'svm_rbf': 0.7797,
    'red_neuronal': 0.7987,
  };

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final data = await AucService.obtenerCurvas();
      if (!mounted) return;
      setState(() {
        _curvas = data;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar curvas: $e')),
      );
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.brown,
      Colors.deepPurple,
      Colors.red,
      Colors.limeAccent,
      Colors.pinkAccent,
    ];

    return _cargando
        ? const Center(child: CircularProgressIndicator())
        : _curvas == null
            ? const Center(child: Text('No se encontraron curvas AUC'))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Curvas AUC por Modelo',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: 1,
                          minY: 0,
                          maxY: 1,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 0.2,
                                getTitlesWidget: (value, _) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Text(value.toStringAsFixed(1)),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 0.2,
                                getTitlesWidget: (value, _) => Text(value.toStringAsFixed(1)),
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: true),
                          lineBarsData: _curvas!.entries.toList().asMap().entries.map((entry) {
                            final i = entry.key;
                            final e = entry.value;
                            final puntos = List.generate(
                              e.value.fpr.length,
                              (j) => FlSpot(e.value.fpr[j], e.value.tpr[j]),
                            );
                            return LineChartBarData(
                              spots: puntos,
                              isCurved: false, // para evitar que se distorsione la curva
                              color: colores[i % colores.length],
                              barWidth: 2,
                              dotData: FlDotData(show: false),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLegend(colores),
                  ],
                ),
              );
  }

  Widget _buildLegend(List<Color> colores) {
    final modelos = _curvas?.keys.toList() ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(modelos.length, (i) {
        final key = modelos[i];
        final nombre = nombresBonitos[key] ?? key;
        final auc = aucValores[key]?.toStringAsFixed(3) ?? '?';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(width: 16, height: 16, color: colores[i % colores.length]),
              const SizedBox(width: 8),
              Text(
                '$nombre (AUC = $auc)',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        );
      }),
    );
  }
}
