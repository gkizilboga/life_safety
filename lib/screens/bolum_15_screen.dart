import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_15_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_16_screen.dart';

class Bolum15Screen extends StatefulWidget {
  const Bolum15Screen({super.key});

  @override
  State<Bolum15Screen> createState() => _Bolum15ScreenState();
}

class _Bolum15ScreenState extends State<Bolum15Screen> {
  Bolum15Model _model = Bolum15Model();

  @override
  void initState() {
    super.initState();
    // HAFIZA DÜZELTMESİ: Veri varsa geri yükle
    if (BinaStore.instance.bolum15 != null) {
      _model = BinaStore.instance.bolum15!;
    }
  }

  void _onNextPressed() {
    BinaStore.instance.bolum15 = _model;
    print("Bölüm 15 Kaydedildi.");
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum16Screen()));  }

  @override
  Widget build(BuildContext context) {
    final bool isHighBuilding = BinaStore.instance.bolum4?.isGenelYuksekBina ?? false;

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Döşemeler ve Tavanlar",
            subtitle: "Bölüm 15: Yalıtım ve Kaplamalar",
            currentStep: 15,
            totalSteps: 15,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ADIM-1
                  const Text("ADIM-1: DÖŞEME KAPLAMALARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Ahşap parke, laminat veya standart halı.",
                          subtitle: isHighBuilding ? "🚨 UYARI: Yüksek binalarda riskli." : "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: isHighBuilding ? "🚨 UYARI" : "✅ OLUMLU"),
                          groupValue: _model.resDosemeKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Taş, seramik, mermer.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "B", reportText: "✅ OLUMLU"),
                          groupValue: _model.resDosemeKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeKaplama: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR"),
                          groupValue: _model.resDosemeKaplama,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeKaplama: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2
                  const Divider(height: 40),
                  const Text("ADIM-2: DÖŞEME ISI YALITIMI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, yok.",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU"),
                          groupValue: _model.resDosemeYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeYalitim: val, resSapDurumu: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, var.",
                          value: ChoiceResult(label: "B", reportText: "Isı yalıtımı mevcut."),
                          groupValue: _model.resDosemeYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeYalitim: val)),
                        ),
                        if (_model.resDosemeYalitim?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Üzerinde şap var mı?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Evet, var.", "✅ OLUMLU", "A", _model.resSapDurumu, (v) => setState(() => _model = _model.copyWith(resSapDurumu: v))),
                          _buildSubOption("Hayır, yok.", "🚨 RİSK", "B", _model.resSapDurumu, (v) => setState(() => _model = _model.copyWith(resSapDurumu: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR"),
                          groupValue: _model.resDosemeYalitim,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDosemeYalitim: val, resSapDurumu: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3
                  const Divider(height: 40),
                  const Text("ADIM-3: TAVAN KAPLAMALARI", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Hayır, tavanlar beton.",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU"),
                          groupValue: _model.resAsmaTavan,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsmaTavan: val, resTavanMalzeme: null)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Evet, asma tavan var.",
                          value: ChoiceResult(label: "B", reportText: "Asma tavan mevcut."),
                          groupValue: _model.resAsmaTavan,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsmaTavan: val)),
                        ),
                        if (_model.resAsmaTavan?.label == "B") ...[
                          const Padding(padding: EdgeInsets.all(8.0), child: Text("Alt Soru: Malzemesi nedir?", style: TextStyle(fontWeight: FontWeight.bold))),
                          _buildSubOption("Alçıpanel/Metal", "✅ OLUMLU", "A", _model.resTavanMalzeme, (v) => setState(() => _model = _model.copyWith(resTavanMalzeme: v))),
                          _buildSubOption("Ahşap/Plastik", "🚨 RİSK", "B", _model.resTavanMalzeme, (v) => setState(() => _model = _model.copyWith(resTavanMalzeme: v))),
                        ],
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR"),
                          groupValue: _model.resAsmaTavan,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resAsmaTavan: val, resTavanMalzeme: null)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-4
                  const Divider(height: 40),
                  const Text("ADIM-4: TESİSAT GEÇİŞLERİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Tam kapalı / Sızdırmaz.",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU"),
                          groupValue: _model.resTesisatGecis,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatGecis: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Boşluklar var.",
                          value: ChoiceResult(label: "B", reportText: "🚨 RİSK"),
                          groupValue: _model.resTesisatGecis,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatGecis: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "C) Bilmiyorum.",
                          value: ChoiceResult(label: "C", reportText: "❓ BİLİNMİYOR"),
                          groupValue: _model.resTesisatGecis,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resTesisatGecis: val)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildSubOption(String text, String subText, String label, ChoiceResult? group, Function(ChoiceResult) onSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 8),
      child: SelectableCard(
        title: text,
        subtitle: subText,
        value: ChoiceResult(label: label, reportText: subText),
        groupValue: group,
        onChanged: (v) => onSelected(v!),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text(" DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_model.resDosemeKaplama == null) return false;
    if (_model.resDosemeYalitim == null) return false;
    if (_model.resDosemeYalitim?.label == "B" && _model.resSapDurumu == null) return false;
    if (_model.resAsmaTavan == null) return false;
    if (_model.resAsmaTavan?.label == "B" && _model.resTavanMalzeme == null) return false;
    if (_model.resTesisatGecis == null) return false;
    return true;
  }
}