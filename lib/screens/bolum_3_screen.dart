import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
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

  String? _normalError;
  String? _bodrumError;
  String? _yukseklikError;

  @override
  void initState() {
    super.initState();
    _normalCtrl.addListener(_validate);
    _bodrumCtrl.addListener(_validate);
    _yukseklikCtrl.addListener(_validate);
  }

  void _validate() {
    setState(() {
      int? n = int.tryParse(_normalCtrl.text);
      if (_normalCtrl.text.isNotEmpty) {
        if (n == null || n < 0 || n > 25) {
          _normalError = "0 ile 25 arasında bir kat sayısı giriniz.";
        } else {
          _normalError = null;
        }
      } else {
        _normalError = null;
      }

      int? b = int.tryParse(_bodrumCtrl.text);
      if (_bodrumCtrl.text.isNotEmpty) {
        if (b == null || b < 0 || b > 10) {
          _bodrumError = "0 ile 10 arasında bir kat sayısı giriniz.";
        } else {
          _bodrumError = null;
        }
      } else {
        _bodrumError = null;
      }

      double? h = double.tryParse(_yukseklikCtrl.text.replaceAll(',', '.'));
      if (_yukseklikCtrl.text.isNotEmpty) {
        if (h == null || h < 2.20 || h > 6.00) {
          _yukseklikError = "2.20m ile 6.00m arasında bir yükseklik giriniz.";
        } else {
          _yukseklikError = null;
        }
      } else {
        _yukseklikError = null;
      }
    });
  }

  bool get _isFormValid {
    if (_normalCtrl.text.isEmpty || _bodrumCtrl.text.isEmpty || _yukseklikCtrl.text.isEmpty) return false;
    return _normalError == null && _bodrumError == null && _yukseklikError == null;
  }

  void _onNextPressed() {
    int n = int.parse(_normalCtrl.text);
    int b = int.parse(_bodrumCtrl.text);
    double h = double.parse(_yukseklikCtrl.text.replaceAll(',', '.'));

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
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Kat Adetleri ve Yükseklik", 
            subtitle: "Binanın dikey ölçülerini giriniz", 
            screenType: widget.runtimeType
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInput("Normal Kat Sayısı (Zemin Dahil)", _normalCtrl, error: _normalError),
                  _buildInput("Bodrum Kat Sayısı", _bodrumCtrl, error: _bodrumError),
                  _buildInput("Ortalama Kat Yüksekliği (Metre)", _yukseklikCtrl, isDecimal: true, error: _yukseklikError),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {bool isDecimal = false, String? error}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        decoration: InputDecoration(
          labelText: label, 
          errorText: error,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white, 
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))]
      ),
      child: ElevatedButton(
        onPressed: _isFormValid ? _onNextPressed : null, 
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text("DEVAM ET", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}