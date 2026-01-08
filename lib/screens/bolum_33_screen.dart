import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart'; 
import '../../widgets/custom_widgets.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});
  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  Bolum33Model _model = Bolum33Model();
  bool _showSummary = false;
  bool _isConfirmed = false;
  String _specialWarning = "";

  void _hesapla() {
    final store = BinaStore.instance;
    final b3 = store.bolum3;
    final b5 = store.bolum5;
    final b9 = store.bolum9;
    final b20 = store.bolum20;

    double hYapi = b3?.hYapi ?? 0.0;
    double alan = b5?.normalKatAlani ?? 0.0;
    bool hasSprinkler = b9?.secim?.label == "9-A";

    int yukNormal = (alan / 20.0).ceil();
    int gerekli = (yukNormal > 50) ? 2 : (hYapi > 21.50 ? 2 : 1);
    int mevcut = (b20?.normalMerdivenSayisi ?? 0) + (b20?.binaIciYanginMerdiveniSayisi ?? 0) + (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0);

    if (gerekli == 1) {
      if (hasSprinkler && alan > 450) {
        _specialWarning = "Binanızda kullanıcı yükü bakımından 1 adet çıkış yeterli gözükse de kat alanın büyük olması sebebiyle, tek yön kaçış mesafesinin 30 metreyi aşacağı tahmin edildiğinden, 2 veya daha fazla çıkış gerekebilir. Detaylı çıkış adedinin belirlenebilemesi için Uzman tarafından kat mimari planının incelenmesi gereklidir.";
      } else if (!hasSprinkler && alan > 600) {
        _specialWarning = "Binanızda kullanıcı yükü bakımından 1 adet çıkış yeterli gözükse de kat alanın büyük olması sebebiyle, tek yön kaçış mesafesinin 15 metreyi aşacağı tahmin edildiğinden, 2 veya daha fazla çıkış gerekebilir. Detaylı çıkış adedinin belirlenebilemesi için Uzman tarafından kat mimari planının incelenmesi gereklidir.";
      }
    }

    setState(() {
      _model = _model.copyWith(yukNormal: yukNormal, gerekliNormal: gerekli, mevcutUst: mevcut);
      _showSummary = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          ModernHeader(title: "Çıkış İmkanı", subtitle: "Kullanıcı yükü Değerlendirmesi", screenType: widget.runtimeType),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(onPressed: _hesapla, child: const Text("DEĞERLENDİR")),
                  if (_showSummary) _buildSummary(),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        const Text("Gereken çıkış sayısı, kaçış mesafelerinin yeterli olması halinde geçerlidir.", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
        if (_specialWarning.isNotEmpty) Container(padding: const EdgeInsets.all(12), color: Colors.amber.shade50, child: Text(_specialWarning, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        CheckboxListTile(value: _isConfirmed, onChanged: (v) => setState(() => _isConfirmed = v!), title: const Text("Değerlendirme sonucunu teyit ederim.")),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))]),
      child: ElevatedButton(onPressed: _isConfirmed ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum34Screen())) : null, child: const Text("DEVAM ET")),
    );
  }
}