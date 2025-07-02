import 'package:flutter/material.dart';
import 'classification_metrics_tab.dart';
import 'auc_curves_tab.dart';
import 'loss_chart_tab.dart';
import 'tiempo_chart_tab.dart';

class ModelComparisonScreen extends StatefulWidget {
  const ModelComparisonScreen({super.key});

  @override
  State<ModelComparisonScreen> createState() => _ModelComparisonScreenState();
}

class _ModelComparisonScreenState extends State<ModelComparisonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparación de Modelos"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black87,
          tabs: const [
            Tab(text: "Métricas de Clasificación"),
            Tab(text: "Curvas AUC"),
            Tab(text: "Loss Rate"),
            Tab(text: "Tiempo de Inferencia"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ClassificationMetricsTab(),
          AucCurvesTab(),
          LossChartTab(),
          TiempoChartTab(),
        ],
      ),
    );
  }
}
