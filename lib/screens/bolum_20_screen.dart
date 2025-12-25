import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_20_model.dart';
import 'bolum_21_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum20Screen extends StatefulWidget {
  const Bolum20Screen({super.key});

  @override
  State<Bolum20Screen> createState() => _Bolum20ScreenState();
}

class _Bolum20ScreenState extends State<Bolum20Screen> {
  Bolum20Model _model = Bolum20Model();

  // Durum değişkenleri
  bool _isTekKatli = false;
  bool _hasBodrum = false;

  // Controller'lar (Çok katlı bina için)
  final _normalCtrl = TextEditingController();
  final _icKapaliCtrl = TextEditingController();
  final _disKapaliCtrl = TextEditingController();
  final _disAcikCtrl = TextEditingController();
  final _donerCtrl = TextEditingController();
  final _sahanliksizCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBuildingInfo();
  }

  void _loadBuildingInfo() {
    final bolum3 = BinaStore.instance.bolum3;
    int nKat = bolum3?.normalKatSayisi ?? 0;
    int bKat = bolum3?.bodrumKatSayisi ?? 0;
    
    // Zemin kat her zaman vardır (+1)
    int toplamKat = nKat + bKat + 1;

    setState(() {
      _isTekKatli = (toplamKat == 1);
      _hasBodrum = (bKat > 0);
    });
  }

  @override
  void dispose() {
    _normalCtrl.dispose();
    _icKapaliCtrl.dispose();
    _disKapaliCtrl.dispose();
    _disAcikCtrl.dispose();
    _donerCtrl.dispose();
    _sahanliksizCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tekKatCikis') _model = _model.copyWith(tekKatCikis: choice);
      if (type == 'tekKatRampa') _model = _model.copyWith(tekKatRampa: choice);
      if (type == 'bodrum') _model = _model.copyWith(bodrumMerdivenDevami: choice);
    });
  }

  void _onNextPressed() {
    if (_isTekKatli) {
      // Tek katlı validasyonları
      if (_model.tekKatCikis == null) return _showError("Lütfen dışarı çıkış durumunu seçiniz.");
      if (_model.tekKatRampa == null) return _showError("Lütfen rampa durumunu seçiniz.");
    } else {
      // Çok katlı validasyonları (Sayısal verileri kaydet)
      // En az bir merdiven girilmiş olmalı
      int normal = int.tryParse(_normalCtrl.text) ?? 0;
      int icKapali = int.tryParse(_icKapaliCtrl.text) ?? 0;
      int disKapali = int.tryParse(_disKapaliCtrl.text) ?? 0;
      int disAcik = int.tryParse(_disAcikCtrl.text) ?? 0;
      int doner = int.tryParse(_donerCtrl.text) ?? 0;
      int sahanliksiz = int.tryParse(_sahanliksizCtrl.text) ?? 0;

      if (normal + icKapali + disKapali + disAcik + doner + sahanliksiz == 0) {
        return _showError("Lütfen binadaki merdiven sayılarını giriniz (En az bir tane).");
      }

      _model = _model.copyWith(
        normalMerdivenSayisi: normal,
        binaIciYanginMerdiveniSayisi: icKapali,
        binaDisiKapaliYanginMerdiveniSayisi: disKapali,
        binaDisiAcikYanginMerdiveniSayisi: disAcik,
        donerMerdivenSayisi: doner,
        sahanliksizMerdivenSayisi: sahanliksiz,
      );
    }

    // Bodrum sorusu (varsa)
    if (_hasBodrum && _model.bodrumMerdivenDevami == null) {
      return _showError("Lütfen bodrum merdiveni devamlılığı sorusunu yanıtlayınız.");
    }

    BinaStore.instance.bolum20 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum21Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-20: Merdivenler",
            subtitle: "Binadaki kaçış merdivenleri.",
            currentStep: 10, 
            totalSteps: 26,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_isTekKatli) ...[
                    // TEK KATLI BİNA SORULARI
                    _buildSoru("Binadan dışarıya (sokağa/caddeye) çıkışınız nasıl?", 'tekKatCikis', 
                      [Bolum20Content.tekKatOptionA], _model.tekKatCikis),
                    
                    _buildSoru("Binadan sokağa çıkarken rampaya basmak veya rampa kullanmak zorunda kalıyor musunuz?", 'tekKatRampa', 
                      [Bolum20Content.rampaOptionB, Bolum20Content.rampaOptionC], _model.tekKatRampa),
                  
                  ] else ...[
                    // ÇOK KATLI BİNA SORULARI (SAYISAL GİRİŞ)
                    QuestionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Binanızda aşağıdaki merdiven türlerinden kaçar tane var? (Merdiven adetlerini mutlaka belirtmeniz gereklidir)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 15),
                          
                          _buildNumberRow(Bolum20Content.cokKatOption1.uiTitle, _normalCtrl),
                          _buildNumberRow(Bolum20Content.cokKatOption2.uiTitle, _icKapaliCtrl),
                          _buildNumberRow(Bolum20Content.cokKatOption3.uiTitle, _disKapaliCtrl),
                          _buildNumberRow(Bolum20Content.cokKatOption4.uiTitle, _disAcikCtrl),
                          _buildNumberRow(Bolum20Content.cokKatOption5.uiTitle, _donerCtrl),
                          _buildNumberRow(Bolum20Content.cokKatOption6.uiTitle, _sahanliksizCtrl),
                        ],
                      ),
                    ),
                  ],

                  // BODRUM SORUSU (HER İKİ DURUMDA DA ÇIKABİLİR)
                  if (_hasBodrum)
                    _buildSoru("Bodrum kata inen merdiveniniz, üst katlara çıkan merdivenin devamı mı?", 'bodrum', 
                      [Bolum20Content.bodrumOptionA, Bolum20Content.bodrumOptionB], _model.bodrumMerdivenDevami),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...options.map((opt) => SelectableCard(
            choice: opt,
            isSelected: selected?.label == opt.label,
            onTap: () => _handleSelection(key, opt),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildNumberRow(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(),
                hintText: "0",
              ),
            ),
          ),
        ],
      ),
    );
  }
}