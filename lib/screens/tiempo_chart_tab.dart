import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/tiempo_service.dart';

class TiempoChartTab extends StatelessWidget {
  const TiempoChartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: TiempoService.obtenerTiempos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tiempos = snapshot.data!;
        final keys = tiempos.keys.toList();
        final values = tiempos.values.toList();

        final abreviaciones = {
          "random_forest": "RF",
          "decision_tree": "DT",
          "xgboost": "XGB",
          "adaboost": "ADA",
          "catboost": "CAT",
          "lightgbm": "LGB",
          "svm_rbf": "SVM",
          "red_neuronal": "MLP",
        };

        return Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Tiempo de Inferencia por Modelo (ms)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 0.1,
                          getTitlesWidget: (value, _) =>
                              Text('${value.toStringAsFixed(2)} ms', style: const TextStyle(fontSize: 10)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 32,
                          getTitlesWidget: (value, _) {
                            final index = value.toInt();
                            if (index >= 0 && index < keys.length) {
                              final nombre = keys[index];
                              return Text(abreviaciones[nombre] ?? nombre, style: const TextStyle(fontSize: 12));
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                    barGroups: List.generate(keys.length, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: values[i],
                            width: 14,
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(2),
                          )
                        ],
                      );
                    }),
                    maxY: 0.5, // Valor fijo para mejor visibilidad
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "RF = Random Forest  \nDT = Decision Tree\n  XGB = XGBoost\n"
                "ADA = AdaBoost  \nCAT = CatBoost  \nLGB = LightGBM\n"
                "SVM = SVM  \nMLP = Red Neuronal",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            )
          ],
        );
      },
    );
  }
}

