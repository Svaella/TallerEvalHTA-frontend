import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'form_screen.dart';
import 'model_comparison_screen.dart'; // ← actualizado

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/heart.png',
                height: 120,
              ),
              const SizedBox(height: 30),
              const Text(
                'HTA Model Evaluation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Evaluación del riesgo de hipertensión arterial con diferentes modelos de predicción.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FormScreen()),
                  );
                },
                child: const Text('Iniciar Evaluación'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModelComparisonScreen()),
                  );
                },
                child: const Text("Ver comparación de modelos"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

