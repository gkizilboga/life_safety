import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_28_model.dart';
import 'bolum_29_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum28Screen extends StatefulWidget {
  const Bolum28Screen({super.key});

  @override
  State<Bolum28Screen> createState() => _Bolum28ScreenState();
}

class _Bolum28ScreenState extends State<Bolum28Screen> {
  Bolum28Model _model = Bolum28Model();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkMuafiyet();
  }

  void _checkMuafiyet() {
    final b3 = BinaStore.instance.bolum3;
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    // Modeldeki normal ve bodrum katları toplayarak toplam katı buluyoruz
    int toplamKat = (b3?.normalKatSayisi ?? 0) + (b3?.bodrumKatSayisi ?? 0);
    
    bool hasTicari = (b6?.hasTicari ?? false);
    if (b10 != null && !hasTicari) {
      hasTicari = (b10.zemin?.label.contains("Ticari") ?? false) || 
                  (b10.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false)) ||
                  (b10.normaller.any((e) => e?.label.contains("Ticari") ?? false));
    }

if (toplamKat <= 4 && !hasTicari) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final muafiyetModel = Bolum28Model(
          muafiyet: Bolum28Content.muafiyetOption,
        );
        BinaStore.instance.bolum28 = muafiyetModel;
        BinaStore.instance.saveToDisk(); // DISKE KAYDET
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum29Screen()),
        );
      });
    }
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

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mesafe') _model = _model.copyWith(mesafe: choice);
      
      if (type == 'dubleks') {
        _model = _model.copyWith(dubleks: choice);
        if (choice.label == Bolum28Content.dubleksOptionA.label) {
          _model = _model.copyWith(alan: null, cikis: null);
        } else {
          _scrollToBottom();
        }
      }

      if (type == 'alan') {
        _model = _model.copyWith(alan: choice);
        if (choice.label == Bolum28Content.alanOption1.label) {
          _model = _model.copyWith(cikis: null);
        } else {
          _scrollToBottom();
        }
      }

      if (type == 'cikis') _model = _model.copyWith(cikis: choice);
    });
  }

  void _onNextPressed() {
    if (_model.mesafe == null) return _showError("Lütfen mesafe sorusunu yanıtlayınız.");
    if (_model.dubleks == null) return _showError("Lütfen daire tipini seçiniz.");

    if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) {
      if (_model.alan == null) return _showError("Lütfen üst kat alanını belirtiniz.");
      if (_model.alan?.label == Bolum28Content.alanOption2.label && _model.cikis == null) {
        return _showError("Lütfen üst kat çıkış kapısı durumunu belirtiniz.");
      }
    }

    BinaStore.instance.bolum28 = _model;
      BinaStore.instance.saveToDisk();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const 
    Bolum29Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-28: Daire İçi Mesafeler",
            subtitle: "Daire içi kaçış uzaklığı ve plan analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSoru("Evinizin içindeki en uzak odadan daire giriş kapısına kadar olan yürüme mesafesi yaklaşık ne kadardır?", 'mesafe', 
                    [Bolum28Content.mesafeOptionA, Bolum28Content.mesafeOptionB, Bolum28Content.mesafeOptionC], _model.mesafe),

                  _buildSoru("Daireniz Dubleks (İki katlı) mi?", 'dubleks', 
                    [Bolum28Content.dubleksOptionA, Bolum28Content.dubleksOptionB], _model.dubleks),

                  if (_model.dubleks?.label == Bolum28Content.dubleksOptionB.label) ...[
                    _buildInfoNote("Dubleks daire seçildiği için üst kat alan bilgisi gereklidir."),
                    _buildSoru("Üst katınızın alanı 70 m²'den büyük mü?", 'alan', 
                      [Bolum28Content.alanOption1, Bolum28Content.alanOption2], _model.alan),
                  ],

                  if (_model.alan?.label == Bolum28Content.alanOption2.label) ...[
                    _buildInfoNote("70 m² üzeri dublekslerde ikinci çıkış kapısı sorgulanmaktadır."),
                    _buildSoru("Üst kattan apartman koridoruna açılan ikinci bir çelik kapı (çıkış) var mı?", 'cikis', 
                      [Bolum28Content.cikisOptionA, Bolum28Content.cikisOptionB], _model.cikis),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomNav(),
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
            onPressed: _onNextPressed,
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 12))),
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
          )),
        ],
      ),
    );
  }
}