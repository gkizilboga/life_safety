import 'package:flutter/material.dart';
import '../data/bina_store.dart';
import '../logic/active_systems_engine.dart';
import '../utils/input_validator.dart';

class ActiveSystemsInputDialog extends StatefulWidget {
  final Function(double? facadeWidth, double? parkingArea) onConfirmed;

  const ActiveSystemsInputDialog({super.key, required this.onConfirmed});

  @override
  State<ActiveSystemsInputDialog> createState() =>
      _ActiveSystemsInputDialogState();
}

class _ActiveSystemsInputDialogState extends State<ActiveSystemsInputDialog> {
  final TextEditingController _facadeController = TextEditingController();
  final TextEditingController _parkingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _needsFacade = false;
  bool _needsParking = false;

  @override
  void initState() {
    super.initState();
    final store = BinaStore.instance;
    _needsFacade = ActiveSystemsEngine.needsFacadeInput(store);
    _needsParking = ActiveSystemsEngine.needsParkingInput(store);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ek Bilgiler"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Aktif sistem gereksinimlerini doğru belirleyebilmek için aşağıdaki eksik bilgilere ihtiyacımız var.",
              ),
              const SizedBox(height: 20),

              // Cephe Genişliği Sorusu
              if (_needsFacade) ...[
                const Text(
                  "En uzun cephenizin uzunluğu kaç metredir?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _facadeController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [InputValidator.flexDecimal],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Örn: 45.50",
                    suffixText: "m",
                  ),
                  validator: (value) => InputValidator.validateNumber(
                    value,
                    min: 0.1,
                    max: 200,
                    unit: "m",
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Otopark Alanı Sorusu
              if (_needsParking) ...[
                const Text(
                  "Toplam Kapalı Otopark Alanı kaç m²?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _parkingController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [InputValidator.flexDecimal],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Örn: 750",
                    suffixText: "m²",
                  ),
                  validator: (value) => InputValidator.validateNumber(
                    value,
                    min: 0.1,
                    max: 15000,
                    unit: "m²",
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // İptal
          child: const Text("İptal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              double? facade = _needsFacade
                  ? double.tryParse(_facadeController.text)
                  : null;
              double? parking = _needsParking
                  ? double.tryParse(_parkingController.text)
                  : null;
              widget.onConfirmed(facade, parking);
              Navigator.pop(context);
            }
          },
          child: const Text("Analizi Göster"),
        ),
      ],
    );
  }
}
