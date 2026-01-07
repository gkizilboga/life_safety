import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../models/choice_result.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});

  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  Bolum33Model _model = Bolum33Model();
  final _zeminCtrl = TextEditingController();
  final _normalCtrl = TextEditingController();
  final _bodrumCtrl = TextEditingController();

  bool _hasNormal = false;
  bool _hasBodrum = false;
  bool _showSummary = false;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final b3 = BinaStore.instance.bolum3;
    final b5 = BinaStore.instance.bolum5;
    setState(() {
      _hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
      _hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;
      _zeminCtrl.text = b5?.tabanAlani?.toString() ?? "";
      _normalCtrl.text = b5?.normalKatAlani?.toString() ?? "";
      _bodrumCtrl.text = b5?.bodrumKatAlani?.toString() ?? "";
    });
  }

  double _getKatsayi(ChoiceResult? choice) {
    if (choice == null) return 20.0;
    final label = choice.label;
    if (label == "10-A") return 20.0;
    if (label == "10-B") return 10.0;
    if (label == "10-C") return 5.0;
    if (label == "10-D") return 1.5;
    if (label == "10-E") return 30.0;
    return 20.0;
  }

  int _hesaplaGerekliCikis(int kisi) {
    if (kisi <= 0) return 0;
    if (kisi <= 50) return 1;
    if (kisi <= 500) return 2;
    if (kisi <= 1000) return 3;
    return 4;
  }

  void _hesapla() {
    final b3 = BinaStore.instance.bolum3;
    final b5 = BinaStore.instance.bolum5;
    final b10 = BinaStore.instance.bolum10;
    final b20 = BinaStore.instance.bolum20;

    if (b5 == null || b10 == null || b3 == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hata: Bina verileri eksik!")));
      return;
    }

    double hBina = b3.hBina ?? 0.0;

    double kZemin = _getKatsayi(b10.zemin);
    double kNormal = _getKatsayi(b10.normaller.isNotEmpty ? b10.normaller.first : null);
    double kBodrum = _getKatsayi(b10.bodrumlar.isNotEmpty ? b10.bodrumlar.first : null);

    int yukZemin = ((b5.tabanAlani ?? 0) / kZemin).ceil();
    int yukNormal = ((b5.normalKatAlani ?? 0) / kNormal).ceil();
    int yukBodrum = ((b5.bodrumKatAlani ?? 0) / kBodrum).ceil();

    int gZeminLoad = _hesaplaGerekliCikis(yukZemin);
    int gNormalLoad = _hesaplaGerekliCikis(yukNormal);
    int gBodrumLoad = _hesaplaGerekliCikis(yukBodrum);

    int minCikisByHeight = 1;
    if (hBina > 21.50) {
      minCikisByHeight = 2;
    }

    int gZemin = math.max(gZeminLoad, minCikisByHeight);
    int gNormal = math.max(gNormalLoad, minCikisByHeight);
    int gBodrum = gBodrumLoad;

    int mevcutUst = (b20?.normalMerdivenSayisi ?? 0) + 
                    (b20?.binaIciYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) + 
                    (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0);
    
    int mevcutBodrum = (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A") ? mevcutUst : 1;

    setState(() {
      _model = _model.copyWith(
        yukZemin: yukZemin, yukNormal: yukNormal, yukBodrum: yukBodrum,
        gerekliZemin: gZemin, gerekliNormal: gNormal, gerekliBodrum: gBodrum,
        mevcutUst: mevcutUst, mevcutBodrum: mevcutBodrum,
      );
      _showSummary = true;
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum33 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum34Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Çıkış İmkanı",
      subtitle: "Kullanıcı yükü Değerlendirmesi",
      screenType: widget.runtimeType,
      isNextEnabled: _showSummary && _isConfirmed,
      onNext: _onNextPressed,
      child: Column(
        children: [
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Bölüm-5'ten Alınan Kat Alanları", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 15),
                _buildReadOnlyInput("Zemin Kat Alanı", _zeminCtrl),
                if (_hasNormal) ...[const SizedBox(height: 12), _buildReadOnlyInput("Normal Kat Alanı", _normalCtrl)],
                if (_hasBodrum) ...[const SizedBox(height: 12), _buildReadOnlyInput("Bodrum Kat Alanı", _bodrumCtrl)],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _hesapla,
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text("DEĞERLENDİR"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E), 
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showSummary) _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildReadOnlyInput(String label, TextEditingController ctrl) {
    return TextFormField(
      controller: ctrl,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label, suffixText: "m²", filled: true, fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), 
        prefixIcon: const Icon(Icons.lock_outline, size: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(16), 
            border: Border.all(color: const Color(0xFF1A237E).withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("📊 HESAPLAMA SONUCU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A237E)))),
              const Divider(height: 30),
              _buildResultRow("ZEMİN KAT", _model.yukZemin, _model.gerekliZemin, _model.mevcutUst),
              if (_hasNormal) ...[const SizedBox(height: 16), _buildResultRow("NORMAL KATLAR", _model.yukNormal, _model.gerekliNormal, _model.mevcutUst)],
              if (_hasBodrum) ...[const SizedBox(height: 16), _buildResultRow("BODRUM KATLAR", _model.yukBodrum, _model.gerekliBodrum, _model.mevcutBodrum)],
              
              const SizedBox(height: 25),
              
              Container(
                decoration: BoxDecoration(
                  color: _isConfirmed ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isConfirmed ? const Color(0xFF1A237E).withOpacity(0.3) : Colors.transparent),
                ),
                child: CheckboxListTile(
                  value: _isConfirmed,
                  onChanged: (v) => setState(() => _isConfirmed = v ?? false),
                  title: const Text(
                    "Hesaplanan değerleri onaylıyorum.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  activeColor: const Color(0xFF1A237E),
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultRow(String title, int? yuk, int? gerekli, int? mevcut) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF2C3E50))),
        const SizedBox(height: 4),
        Text("• Tahmini Kişi Sayısı: ${yuk ?? 0} Kişi", style: const TextStyle(fontSize: 13)),
        Text("• Gereken Çıkış: $gerekli | Mevcut Çıkış: $mevcut", style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}