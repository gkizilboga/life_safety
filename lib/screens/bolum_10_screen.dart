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

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice, {int? index}) {
    setState(() {
      _isSummaryAccepted = false; // Her seçimde onayı sıfırla
      if (type == 'zemin') {
        _model = _model.copyWith(zemin: choice);
        _scrollToBottom();
      } else if (type == 'bodrum') {
        List<ChoiceResult?> newList = List.from(_model.bodrumlar);
        if (_model.bodrumlarAyni) {
          newList = List.filled(newList.length, choice);
        } else if (index != null) {
          newList[index] = choice;
        }
        _model = _model.copyWith(bodrumlar: newList);
      } else if (type == 'normal') {
        List<ChoiceResult?> newList = List.from(_model.normaller);
        if (_model.normallerAyni) {
          newList = List.filled(newList.length, choice);
        } else if (index != null) {
          newList[index] = choice;
        }
        _model = _model.copyWith(normaller: newList);
      }
    });
  }

  // KRİTİK DÜZELTME: Doğrulama Mantığı
  bool _checkIfComplete() {
    if (_model.zemin == null) return false;
    if (_model.bodrumlar.any((e) => e == null)) return false;
    if (_model.normaller.any((e) => e == null)) return false;
    return true;
  }

  void _onNextPressed() {
    if (!_checkIfComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen tüm katların kullanım amacını seçiniz!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isSummaryAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen önce özeti onaylayınız.")),
      );
      return;
    }

    BinaStore.instance.bolum10 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum11Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-10: Kat Kullanım Amaçları",
            subtitle: "Her katın fonksiyonel yükünü belirleyin",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Zemin Kat"),
                  QuestionCard(
                    child: _buildChoiceGrid('zemin', null, _model.zemin),
                  ),

                  if (_model.bodrumlar.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildSectionTitle("Bodrum Katlar"),
                    _buildToggleRow("Tüm bodrumlar aynı", _model.bodrumlarAyni, (val) {
                      setState(() => _model = _model.copyWith(bodrumlarAyni: val));
                    }),
                    if (_model.bodrumlarAyni)
                      QuestionCard(child: _buildChoiceGrid('bodrum', 0, _model.bodrumlar[0]))
                    else
                      ...List.generate(_model.bodrumlar.length, (i) => 
                        QuestionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${i + 1}. Bodrum Kat", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              _buildChoiceGrid('bodrum', i, _model.bodrumlar[i]),
                            ],
                          ),
                        ),
                      ),
                  ],

                  if (_model.normaller.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _buildSectionTitle("Normal Katlar"),
                    _buildToggleRow("Tüm normal katlar aynı", _model.normallerAyni, (val) {
                      setState(() => _model = _model.copyWith(normallerAyni: val));
                    }),
                    if (_model.normallerAyni)
                      QuestionCard(child: _buildChoiceGrid('normal', 0, _model.normaller[0]))
                    else
                      ...List.generate(_model.normaller.length, (i) => 
                        QuestionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${i + 1}. Normal Kat", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              _buildChoiceGrid('normal', i, _model.normaller[i]),
                            ],
                          ),
                        ),
                      ),
                  ],

                  if (_checkIfComplete()) _buildSummaryCard(),
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
    final choices = [
      Bolum10Content.konut,
      Bolum10Content.azYogunTicari,
      Bolum10Content.ortaYogunTicari,
      Bolum10Content.yuksekYogunTicari,
      Bolum10Content.teknikDepo,
    ];

    return GridView.builder(
      shrinkWrap: true, // İçeriğe göre boyutu ayarlar
      physics: const NeverScrollableScrollPhysics(), // Kendi içinde kaydırmayı kapatır
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Yan yana 2 kutucuk
        crossAxisSpacing: 12, // Yatay boşluk
        mainAxisSpacing: 12, // Dikey boşluk
        childAspectRatio: 2.2, // Kutucukların genişlik/yükseklik oranı (Genişletmek için burayı küçültebilirsin)
      ),
      itemCount: choices.length,
      itemBuilder: (context, i) {
        final c = choices[i];
        return SelectableCard(
          choice: c,
          isSelected: selected?.label == c.label,
          onTap: () => _handleSelection(type, c, index: index),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFF1A237E)),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Kat Bilgileri Tamamlandı", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            title: const Text("Kat kullanım amaçlarını doğru işaretlediğimi onaylıyorum.", style: TextStyle(fontSize: 13)),
            value: _isSummaryAccepted,
            onChanged: (val) => setState(() => _isSummaryAccepted = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_checkIfComplete() && _isSummaryAccepted) ? _onNextPressed : null,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }
}