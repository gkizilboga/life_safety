import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_18_model.dart';
import 'bolum_19_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum18Screen extends StatefulWidget {
  const Bolum18Screen({super.key});

  @override
  State<Bolum18Screen> createState() => _Bolum18ScreenState();
}

class _Bolum18ScreenState extends State<Bolum18Screen> {
  Bolum18Model _model = Bolum18Model();

  // Boru sorusunu sadece Yüksek Binalarda soracağız
  bool _askBoru = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum18 != null) {
      _model = BinaStore.instance.bolum18!;
    }
    _checkBinaYuksekligi();
  }

  void _checkBinaYuksekligi() {
    // Bölüm 4'ten hesaplanan bina yüksekliğini al
    // Eğer H_Bina >= 21.50m ise boru sorusu sorulmalı
    final bolum4 = BinaStore.instance.bolum4;
    final hBina = bolum4?.hesaplananBinaYuksekligi ?? 0.0;

    if (hBina >= 21.50) {
      setState(() {
        _askBoru = true;
      });
    }
  }

  final GlobalKey _boruKey = GlobalKey();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'duvar') {
        _model = _model.copyWith(duvarKaplama: choice);
      }
      if (type == 'boru') _model = _model.copyWith(boruTipi: choice);
    });
  }

  void _onNextPressed() {
    if (_model.duvarKaplama == null)
      return _showError("Lütfen duvar kaplama sorusunu yanıtlayınız.");

    // Yüksek binaysa boru sorusu zorunlu
    if (_askBoru && _model.boruTipi == null)
      return _showError("Lütfen tesisat borusu sorusunu yanıtlayınız.");

    BinaStore.instance.bolum18 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum19Screen()),
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
          ModernHeader(
            title: "Bölüm-18: İç Duvarlar",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Duvar Kaplaması
                  _buildSoru(
                    "Daire içlerinde veya koridor duvarlarında; kağıt, ahşap, plastik veya köpük (içten yalıtım) gibi bir kaplama var mı?",
                    'duvar',
                    [
                      Bolum18Content.duvarOptionA,
                      Bolum18Content.duvarOptionB,
                      Bolum18Content.duvarOptionC,
                      Bolum18Content.duvarOptionD,
                    ],
                    _model.duvarKaplama,
                  ),

                  // 2. Tesisat Borusu (Sadece Yüksek Binalarda)
                  if (_askBoru) ...[
                    const Divider(height: 30),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "⚠️ Binanız 'Yüksek Bina' statüsünde olduğu için aşağıdaki soru açılmıştır.",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(key: _boruKey, height: 1),
                    _buildSoru(
                      "Binanız yüksek katlı olduğu için tesisat şaftlarından geçen plastik su borularında önlem alınmış mı?",
                      'boru',
                      [
                        Bolum18Content.boruOptionA,
                        Bolum18Content.boruOptionB,
                        Bolum18Content.boruOptionC,
                        Bolum18Content.boruOptionD,
                      ],
                      _model.boruTipi,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
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

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 10),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () => _handleSelection(key, opt),
            ),
          ),
        ],
      ),
    );
  }
}
