import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_3_model.dart';
import 'package:life_safety/models/bolum_4_model.dart';
import 'package:life_safety/screens/bolum_5_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart';

class Bolum3Screen extends StatefulWidget {
  const Bolum3Screen({super.key});

  @override
  State<Bolum3Screen> createState() => _Bolum3ScreenState();
}

class _Bolum3ScreenState extends State<Bolum3Screen> {
  Bolum3Model _model = Bolum3Model();
  
  final TextEditingController _normalKatCtrl = TextEditingController();
  final TextEditingController _bodrumKatCtrl = TextEditingController();
  final TextEditingController _hZeminCtrl = TextEditingController();
  final TextEditingController _hNormalCtrl = TextEditingController();
  final TextEditingController _hBodrumCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum3 != null) {
      _model = BinaStore.instance.bolum3!;
      if (_model.normalKatSayisi != null) _normalKatCtrl.text = _model.normalKatSayisi.toString();
      if (_model.bodrumKatSayisi != null) _bodrumKatCtrl.text = _model.bodrumKatSayisi.toString();
      if (_model.hKatZeminManuel != null) _hZeminCtrl.text = _model.hKatZeminManuel.toString();
      if (_model.hKatNormalManuel != null) _hNormalCtrl.text = _model.hKatNormalManuel.toString();
      if (_model.hKatBodrumManuel != null) _hBodrumCtrl.text = _model.hKatBodrumManuel.toString();
    }
  }

  @override
  void dispose() {
    _normalKatCtrl.dispose();
    _bodrumKatCtrl.dispose();
    _hZeminCtrl.dispose();
    _hNormalCtrl.dispose();
    _hBodrumCtrl.dispose();
    super.dispose();
  }

  void _updateNormalKat(String value) {
    if (value.isEmpty) {
      setState(() => _model = _model.copyWith(normalKatSayisi: null));
      return;
    }
    int? val = int.tryParse(value);
    if (val != null) {
      if (val > 20) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen 20 kattan daha az bir değer giriniz.")),
        );
        _normalKatCtrl.text = "20";
        val = 20;
      }
      setState(() => _model = _model.copyWith(normalKatSayisi: val));
    }
  }

  void _updateBodrumKat(String value) {
    if (value.isEmpty) {
      setState(() => _model = _model.copyWith(bodrumKatSayisi: null));
      return;
    }
    int? val = int.tryParse(value);
    if (val != null) {
      if (val > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen 10 kattan daha az bir değer giriniz.")),
        );
        _bodrumKatCtrl.text = "10";
        val = 10;
      }
      setState(() => _model = _model.copyWith(bodrumKatSayisi: val));
    }
  }

  void _onCalculatePressed() {
    if (_model.normalKatSayisi == null || _model.bodrumKatSayisi == null || _model.yukseklikGirisTipi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurunuz.")),
      );
      return;
    }
    
    if (_model.yukseklikGirisTipi == YukseklikGirisTipi.hassas) {
      if ((_model.hKatZeminManuel ?? 0) < 2.0 || (_model.hKatZeminManuel ?? 0) > 7.0) {
        _showError("Zemin kat yüksekliği 2.00m ile 7.00m arasında olmalıdır.");
        return;
      }
      if (_model.normalKatSayisi! > 0) {
         if ((_model.hKatNormalManuel ?? 0) < 2.0 || (_model.hKatNormalManuel ?? 0) > 4.5) {
          _showError("Normal kat yüksekliği 2.00m ile 4.50m arasında olmalıdır.");
          return;
        }
      }
      if (_model.bodrumKatSayisi! > 0) {
         if ((_model.hKatBodrumManuel ?? 0) < 2.0 || (_model.hKatBodrumManuel ?? 0) > 7.0) {
          _showError("Bodrum kat yüksekliği 2.00m ile 7.00m arasında olmalıdır.");
          return;
        }
      }
    }

    _showSummaryDialog();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  Future<void> _showSummaryDialog() async {
    bool isConfirmed = false;
    
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("YÜKSEKLİK ÖZETİ"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    const Text("Lütfen bina ölçülerinizi kontrol ediniz.", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text("KAT BİLGİLERİ:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text("• Zemin Üstü: ${_model.normalKatSayisi} Kat"),
                    Text("• Zemin Altı: ${_model.bodrumKatSayisi} Kat"),
                    const SizedBox(height: 15),
                    const Text("HESAPLANAN TOPLAM YÜKSEKLİK:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text("• Bina Yüksekliği (H): ${_model.hBina.toStringAsFixed(2)} metre 🔒", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("• Yapı Yüksekliği (H_yapı): ${_model.hYapi.toStringAsFixed(2)} metre 🔒"),
                    const SizedBox(height: 15),
                    const Text("STATÜ:", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _model.isGenelYuksekBina ? Colors.red.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _model.isGenelYuksekBina ? "KIRMIZI: YÜKSEK BİNA" : "YEŞİL: YÜKSEK OLMAYAN BİNA",
                        style: TextStyle(
                          color: _model.isGenelYuksekBina ? Colors.red.shade900 : Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: isConfirmed,
                          onChanged: (val) {
                            setStateDialog(() {
                              isConfirmed = val ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text("Yukarıdaki kat ve yükseklik bilgilerinin doğruluğunu teyit ediyorum.", style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Hata Var, Düzenle"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  onPressed: isConfirmed ? () {
                    Navigator.of(context).pop();
                    _navigateToNext();
                  } : null,
                  child: const Text("Onayla ve Devam Et"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _navigateToNext() {
    final double gelenHBina = _model.hBina;
    final double gelenHYapi = _model.hYapi;
    final Bolum4Model bolum4Sonuc = Bolum4Model(hBina: gelenHBina, hYapi: gelenHYapi);

    BinaStore.instance.bolum3 = _model;
    BinaStore.instance.bolum4 = bolum4Sonuc;

    print("Bölüm 3 ve 4 Kaydedildi.");
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kat Bilgileri",
            subtitle: "Bölüm 3: Kat Sayısı ve Yükseklik",
            currentStep: 3,
            totalSteps: 21,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("BİNA KAT BİLGİLERİ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 20),
                  _buildLockedInput("Zemin Kat", "1"),
                  const SizedBox(height: 15),
                  _buildNumberInput(label: "Normal Kat Adedi", hint: "Örn: 5", controller: _normalKatCtrl, onChanged: _updateNormalKat, helperText: "Sadece 0-20 arası tam sayı."),
                  const SizedBox(height: 15),
                  _buildNumberInput(label: "Bodrum Kat Adedi", hint: "Bodrum yoksa 0", controller: _bodrumKatCtrl, onChanged: _updateBodrumKat, helperText: "Sadece 0-10 arası tam sayı."),
                  const SizedBox(height: 30),
                  const Text("KAT YÜKSEKLİKLERİ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  SelectableCard<YukseklikGirisTipi>(
                    title: "A) Kat yüksekliklerini biliyorum.",
                    value: YukseklikGirisTipi.hassas,
                    groupValue: _model.yukseklikGirisTipi,
                    onChanged: (val) => setState(() => _model = _model.copyWith(yukseklikGirisTipi: val)),
                  ),
                  SelectableCard<YukseklikGirisTipi>(
                    title: "B) Bilmiyorum / Standart değerleri kabul et.",
                    subtitle: "Zemin: 3.5m, Normal: 3.0m, Bodrum: 3.5m",
                    value: YukseklikGirisTipi.standart,
                    groupValue: _model.yukseklikGirisTipi,
                    onChanged: (val) => setState(() => _model = _model.copyWith(yukseklikGirisTipi: val)),
                  ),
                  if (_model.yukseklikGirisTipi == YukseklikGirisTipi.hassas) ...[
                    const SizedBox(height: 15),
                    _buildDecimalInput("Zemin Kat Yüksekliği", _hZeminCtrl, (val) => setState(() => _model = _model.copyWith(hKatZeminManuel: double.tryParse(val)))),
                    if ((_model.normalKatSayisi ?? 0) > 0) ...[
                      const SizedBox(height: 10),
                      _buildDecimalInput("Normal Kat Yüksekliği", _hNormalCtrl, (val) => setState(() => _model = _model.copyWith(hKatNormalManuel: double.tryParse(val)))),
                    ],
                    if ((_model.bodrumKatSayisi ?? 0) > 0) ...[
                      const SizedBox(height: 10),
                      _buildDecimalInput("Bodrum Kat Yüksekliği", _hBodrumCtrl, (val) => setState(() => _model = _model.copyWith(hKatBodrumManuel: double.tryParse(val)))),
                    ],
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))]),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onCalculatePressed,
                  child: const Text("HESAPLA"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedInput(String label, String value) {
    return TextField(
      enabled: false,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), filled: true, fillColor: Colors.grey.shade200),
    );
  }

  Widget _buildNumberInput({required String label, required String hint, required TextEditingController controller, required Function(String) onChanged, required String helperText}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, hintText: hint, helperText: helperText, border: const OutlineInputBorder()),
    );
  }

  Widget _buildDecimalInput(String label, TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label, suffixText: "m", border: const OutlineInputBorder()),
    );
  }
}