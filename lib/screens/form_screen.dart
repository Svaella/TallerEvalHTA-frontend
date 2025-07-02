import 'package:flutter/material.dart';
import 'package:hta_evalmodel_ui/widgets/input_form.dart';
import 'package:hta_evalmodel_ui/screens/model_selector_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formData = {
    "Sexo": "Seleccionar",
    "Edad": '',
    "Peso": '',
    "Altura": '',
    "MentHlth": '',
    "Sal": "Seleccionar",
    "Actividad": "Seleccionar",
    "Fuma": "Seleccionar",
    "Vapeo": "Seleccionar",
    "Alcohol30d": "Seleccionar",
    "Diabetes": "Seleccionar",
    "Colesterol": "Seleccionar",
  };

  void _goToModelSelection() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ModelSelectorScreen(factors: _formData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación de Riesgo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              InputForm(
                formData: _formData,
                onChanged: (key, value) {
                  setState(() {
                    _formData[key] = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _goToModelSelection,
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

