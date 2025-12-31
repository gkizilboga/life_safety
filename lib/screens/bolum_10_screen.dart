import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_10_model.dart';
import 'bolum_11_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum10Screen extends StatefulWidget {
  const Bolum10Screen({super.key});

  @override
  State<Bolum10Screen> createState() => _Bolum10ScreenState();
}

class _Bolum10ScreenState extends State<Bolum10Screen> {
  Bolum10Model _model = Bolum10Model();
  final ScrollController _scrollController = ScrollController();
  bool _isSummaryAccepted = false;

  final GlobalKey _bodrumKey = GlobalKey();
  final GlobalKey _normalKey = GlobalKey();
  final GlobalKey _summaryKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final b3 = BinaStore.instance.bolum3;
    int bCount = int.tryParse(b3?.bodrumKatSayisi?.toString() ?? "0") ?? 0;
    int nCount = int.tryParse(b3?.normalKatSayisi?.toString() ?? "0") ?? 0;

    _model = Bolum10Model(
      bodrumlar: List.filled(bCount, null),
      normaller: List.filled(nCount, null),
      bodrumlarAyni: true,
      normallerAyni: true,
    );
  }

  void _scrollToSection(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice, {int? index}) {
    setState(() {
      _isSummaryAccepted = false;
      if (type == 'zemin') {
        _model = _model.copyWith(zemin: choice);
        if (_model.bodrumlar.isNotEmpty) {
          _scrollToSection(_bodrumKey);
        } else if (_model.normaller.isNotEmpty) {
          _scrollToSection(_normalKey);
        }
      } else if (type == 'bodrum') {
        List<ChoiceResult?> newList = List.from(_model.bodrumlar);
        if (_model.bodrumlarAyni) {
          newList = List.filled(newList.length, choice);
          _model = _model.copyWith(bodrumlar: newList);
          if (_model.normaller.isNotEmpty) _scrollToSection(_normalKey);
        } else {
          if (index != null) newList[index] = choice;
          _model = _model.copyWith(bodrumlar: newList);
        }
      } else if (type == 'normal') {
        List<ChoiceResult?> newList = List.from(_model.normaller);
        if (_model.normallerAyni) {
          newList = List.filled(newList.length, choice);
          _model = _model.copyWith(normaller: newList);
          if (_checkIfComplete()) _scrollToSection(_summaryKey);
        } else {
          if (index != null) newList[index] = choice;
          _model = _model.copyWith(normaller: newList);
        }
      }
    });
  }

  bool _checkIfComplete() {
    if (_model.zemin == null) return false;
    if (_model.bodrumlar.any((e) => e == null)) return false;
    if (_model.normaller.any((e) => e == null)) return false;
    return true;
  }

  void _onNextPressed() {
    if (!_checkIfComplete() || !_isSummaryAccepted) return;
    BinaStore.instance.bolum10 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum11Screen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          ModernHeader(
            title: "Kat Kullanım Amaçları",
            subtitle: "Her katın fonksiyonel yükünü belirleyin",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Zemin Kat"),
                  _buildChoiceGrid('zemin', null, _model.zemin),

                  if (_model.bodrumlar.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle("Bodrum Katlar", key: _bodrumKey),
                    _buildToggleRow("Tüm bodrumlar aynı", _model.bodrumlarAyni, (val) {
                      setState(() => _model = _model.copyWith(bodrumlarAyni: val));
                    }),
                    if (_model.bodrumlarAyni)
                      _buildChoiceGrid('bodrum', 0, _model.bodrumlar[0])
                    else
                      ...List.generate(_model.bodrumlar.length, (i) => 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              // DÜZELTİLEN SATIR: EdgeInsets.only kullanıldı
                              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
                              child: Text("${i + 1}. Bodrum Kat", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                            _buildChoiceGrid('bodrum', i, _model.bodrumlar[i]),
                          ],
                        ),
                      ),
                  ],

                  if (_model.normaller.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle("Normal Katlar", key: _normalKey),
                    _buildToggleRow("Tüm normal katlar aynı", _model.normallerAyni, (val) {
                      setState(() => _model = _model.copyWith(normallerAyni: val));
                    }),
                    if (_model.normallerAyni)
                      _buildChoiceGrid('normal', 0, _model.normaller[0])
                    else
                      ...List.generate(_model.normaller.length, (i) => 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              // DÜZELTİLEN SATIR: EdgeInsets.only kullanıldı
                              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 4),
                              child: Text("${i + 1}. Normal Kat", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            ),
                            _buildChoiceGrid('normal', i, _model.normaller[i]),
                          ],
                        ),
                      ),
                  ],

                  if (_checkIfComplete()) 
                    Padding(
                      key: _summaryKey,
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildSummaryCard(),
                    ),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildChoiceGrid(String type, int? index, ChoiceResult? selected) {
    final bool hasTicari = BinaStore.instance.bolum6?.hasTicari ?? false;
    final choices = [
      Bolum10Content.konut,
      Bolum10Content.azYogunTicari,
      Bolum10Content.ortaYogunTicari,
      Bolum10Content.yuksekYogunTicari,
      Bolum10Content.teknikDepo,
    ].where((c) => hasTicari ? true : !c.label.contains("Ticari")).toList();

    double cardWidth = (MediaQuery.of(context).size.width - 48) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: choices.map((c) => SizedBox(
        width: cardWidth,
        child: SelectableCard(
          choice: c,
          isSelected: selected?.label == c.label,
          onTap: () => _handleSelection(type, c, index: index),
        ),
      )).toList(),
    );
  }

  Widget _buildSectionTitle(String title, {GlobalKey? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.8,
            child: Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF1A237E)),
          ),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text("Kat Bilgileri Tamamlandı", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          CheckboxListTile(
            title: const Text("Kat kullanım amaçlarını doğru işaretlediğimi onaylıyorum.", style: TextStyle(fontSize: 13)),
            value: _isSummaryAccepted,
            onChanged: (val) => setState(() => _isSummaryAccepted = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: (_checkIfComplete() && _isSummaryAccepted) ? _onNextPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("ANALİZE DEVAM ET", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}