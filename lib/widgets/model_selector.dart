import 'package:flutter/material.dart';

class ModelSelector extends StatelessWidget {
  final String selectedModel;
  final Function(String) onChanged;

  const ModelSelector({
    Key? key,
    required this.selectedModel,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final modelos = {
      'random_forest': 'Random Forest',
      'decision_tree': 'Decision Tree',
      'xgboost': 'XGBoost',
      'adabbost': 'Adaboost',
      'lightgbm': 'LightGBM',
      'catboost': 'CatBoost',
      'svm_rbf': 'SVM',
      'red_neuronal': 'Red Neuronal'
    };

    return DropdownButtonFormField<String>(
      value: selectedModel,
      decoration: const InputDecoration(
        labelText: "Modelo a usar",
      ),
      style: const TextStyle(color: Colors.white), // texto del campo
      dropdownColor: Colors.grey[900],             // fondo del menú desplegable
      items: modelos.entries
          .map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
