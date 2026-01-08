import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_4_screen.dart';
import '../../widgets/custom_widgets.dart';

class Bolum3Screen extends StatefulWidget {
  const Bolum3Screen({super.key});
  @override
  State<Bolum3Screen> createState() => _Bolum3ScreenState();
}

class _Bolum3ScreenState extends State<Bolum3Screen> {
  final _normalCtrl = TextEditingController();
  final _bodrumCtrl = TextEditingController();
  final _yukseklikCtrl = TextEditingController();

  void _onNextPressed() {
    int n = int.tryParse(_normalCtrl.text) ?? 0;
    int b = int.tryParse(_bodrumCtrl.text) ?? 0;
    double h = double.tryParse(_yukseklikCtrl.text.replaceAll(',', '.')) ?? 0.0;

    double hBina = n * h;
    double hYapi = (n + b) * h;
    bool isYuksek = (hBina >= 21.50) || (hYapi >= 30.50);

    BinaStore.instance.bolum3 = Bolum3Model(
      normalKatSayisi: n,
      bodrumKatSayisi: b,
      katYuksekligi: h,
      hBina: hBina,
      hYapi: hYapi,
      isYuksekBina: isYuksek,
    );
    BinaStore.instance.saveToDisk();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum4Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          ModernHeader(title: "Kat Adetleri ve Yükseklik", subtitle: "Binanın dikey ölçülerini giriniz", screenType: widget.runtimeType),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInput("Normal Kat Sayısı (Zemin Dahil)", _normalCtrl),
                  _buildInput("Bodrum Kat Sayısı", _bodrumCtrl),
                  _buildInput("Ortalama Kat Yüksekliği (Metre)", _yukseklikCtrl, isDecimal: true),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {bool isDecimal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))]),
      child: ElevatedButton(onPressed: _onNextPressed, child: const Text("DEVAM ET")),
    );
  }
}