import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/loss_service.dart';

class LossChartTab extends StatelessWidget {
  const LossChartTab({super.key});

  static const abreviaciones = {
    "random_forest": "RF",
    "decision_tree": "DT",
    "xgboost": "XGB",
    "adaboost": "ADA",
    "catboost": "CAT",
    "lightgbm": "LGB",
    "svm_rbf": "SVM",
    "red_neuronal": "MLP",
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, LossRate>>(
      future: LossService.obtenerLossRates(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final data = snapshot.data!;
        final modelos = data.keys.toList();
        final entrenamiento = modelos.map((m) => data[m]!.train).toList();
        final prueba = modelos.map((m) => data[m]!.test).toList();

        return Column(
          children: [
            const SizedBox(height: 16),
            const Text("Loss Rate por Modelo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BarChart(
                  BarChartData(
                    maxY: 1.0,
                    barGroups: List.generate(modelos.length, (i) {
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(toY: entrenamiento[i], color: Colors.blue, width: 8),
                        BarChartRodData(toY: prueba[i], color: Colors.red, width: 8),
                      ]);
                    }),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.2,
                          getTitlesWidget: (value, _) {
                            final valoresPermitidos = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0];
                            if (valoresPermitidos.contains(double.parse(value.toStringAsFixed(1)))) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            final i = value.toInt();
                            if (i < modelos.length) {
                              final abbr = abreviaciones[modelos[i]] ?? modelos[i];
                              return Text(abbr, style: const TextStyle(color: Colors.white, fontSize: 11));
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    alignment: BarChartAlignment.spaceAround,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 10, color: Colors.blue),
                SizedBox(width: 4),
                Text("Entrenamiento", style: TextStyle(color: Colors.white)),
                SizedBox(width: 16),
                Icon(Icons.circle, size: 10, color: Colors.red),
                SizedBox(width: 4),
                Text("Prueba", style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "RF = Random Forest  \nDT = Decision Tree\n  XGB = XGBoost\n"
                "ADA = AdaBoost  \nCAT = CatBoost  \nLGB = LightGBM\n"
                "SVM = SVM  \nMLP = Red Neuronal",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
