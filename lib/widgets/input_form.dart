import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputForm extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onChanged;

  const InputForm({
    Key? key,
    required this.formData,
    required this.onChanged,
  }) : super(key: key);

  Widget _buildTextField(
    String label,
    String keyName,
    TextInputType inputType, {
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      initialValue: formData[keyName]?.toString(),
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: (value) => onChanged(keyName, value),
      autovalidateMode: AutovalidateMode.onUserInteraction, // Validación inmediata
    );
  }

  Widget _buildDropdown(String label, String keyName, List<String> opciones) {
    final allOptions = ['Seleccionar', ...opciones];
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      value: formData[keyName] == '' ? 'Seleccionar' : formData[keyName],
      items: allOptions
          .map((op) => DropdownMenuItem(value: op, child: Text(op)))
          .toList(),
      dropdownColor: Colors.grey[900],
      onChanged: (value) => onChanged(keyName, value),
      validator: (value) {
        if (value == null || value == 'Seleccionar') return 'Seleccione una opción';
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildDropdown("Sexo", "Sexo", ["Hombre", "Mujer"]),
        const SizedBox(height: 24),

        _buildTextField(
          "Edad", "Edad", TextInputType.number,
          hintText: "Ingrese su edad",
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obligatorio';
            final edad = int.tryParse(value);
            if (edad == null || edad < 18 || edad > 100) return 'Debe estar entre 18 y 100 años';
            return null;
          },
        ),
        const SizedBox(height: 24),

        _buildTextField(
          "Peso (kg)", "Peso", TextInputType.numberWithOptions(decimal: true),
          hintText: "Kg",
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,1})?'))],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obligatorio';
            final peso = double.tryParse(value);
            if (peso == null || peso < 20 || peso > 180) return 'Debe estar entre 20 y 180 kg';
            return null;
          },
        ),
        const SizedBox(height: 24),

        _buildTextField(
          "Altura (cm)", "Altura", TextInputType.numberWithOptions(decimal: true),
          hintText: "Cm",
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,1})?'))],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obligatorio';
            final altura = double.tryParse(value);
            if (altura == null || altura < 100 || altura > 220) return 'Debe estar entre 100 y 220 cm';
            return null;
          },
        ),
        const SizedBox(height: 24),

        _buildTextField(
          "Días con mal estado de ánimo en el último mes", "MentHlth", TextInputType.number,
          hintText: "Ingrese número de días",
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo obligatorio';
            final mh = int.tryParse(value);
            if (mh == null || mh < 0 || mh > 30) return 'Debe estar entre 0 y 30 días';
            return null;
          },
        ),
        const SizedBox(height: 24),

        _buildDropdown("Controla el consumo de sal", "Sal", ["Sí", "No"]),
        const SizedBox(height: 24),
        _buildDropdown("Actividad física diaria", "Actividad", ["Sí", "No"]),
        const SizedBox(height: 24),
        _buildDropdown("Frecuencia de fumar", "Fuma", [
          "Fumador Actual - Todos los días",
          "Fumador Actual - Algunos días",
          "Exfumador",
          "No Fumo",
        ]),
        const SizedBox(height: 24),
        _buildDropdown("Uso de vapeo", "Vapeo", [
          "Todos los días",
          "Algunos días",
          "Raramente",
          "Nunca he usado",
        ]),
        const SizedBox(height: 24),
        _buildDropdown("Consumo de alcohol en los últimos 30 días", "Alcohol30d", ["Sí", "No"]),
        const SizedBox(height: 24),
        _buildDropdown("¿Diagnóstico médico de diabetes?", "Diabetes", ["Sí", "No"]),
        const SizedBox(height: 24),
        _buildDropdown("¿Diagnóstico de colesterol alto?", "Colesterol", ["Sí", "No"]),
      ],
    );
  }
}
