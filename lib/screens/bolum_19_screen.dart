import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_19_model.dart';
import 'bolum_20_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum19Screen extends StatefulWidget {
  const Bolum19Screen({super.key});

  @override
  State<Bolum19Screen> createState() => _Bolum19ScreenState();
}

class _Bolum19ScreenState extends State<Bolum19Screen> {
  Bolum19Model _model = Bolum19Model();
  final ScrollController _scrollController = ScrollController();

  // Otomatik Kaydırma Fonksiyonu
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

  // Soru 1: Çoklu Seçim Mantığı
  void _handleEngelSelection(ChoiceResult choice) {
    setState(() {
      List<ChoiceResult> current = List.from(_model.engeller);
      
      if (choice.label == Bolum19Content.engelOptionA.label) {
        // A seçilirse her şeyi temizle ve sadece A'yı ekle
        current = [choice];
      } else {
        // B, C veya D seçilirse A'yı listeden çıkar
        current.removeWhere((e) => e.label == Bolum19Content.engelOptionA.label);
        
        if (current.any((e) => e.label == choice.label)) {
          current.removeWhere((e) => e.label == choice.label);
        } else {
          current.add(choice);
        }
      }
      _model = _model.copyWith(engeller: current);
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'levha') _model = _model.copyWith(levha: choice);
      if (type == 'etiket') _model = _model.copyWith(yanilticiEtiket: choice);
      
      if (type == 'yaniltici') {
        _model = _model.copyWith(yanilticiKapi: choice);
        if (choice.label == Bolum19Content.yanilticiOptionB.label) {
          _scrollToBottom(); // Alt soru açılınca kaydır
        } else {
          _model = _model.copyWith(yanilticiEtiket: null);
        }
      }
    });
  }

  void _onNextPressed() {
    if (_model.engeller.isEmpty) return _showError("Lütfen engeller sorusunu yanıtlayınız.");
    if (_model.levha == null) return _showError("Lütfen yönlendirme levhaları sorusunu yanıtlayınız.");
    if (_model.yanilticiKapi == null) return _showError("Lütfen yanıltıcı kapı sorusunu yanıtlayınız.");
    
    if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label && _model.yanilticiEtiket == null) {
      return _showError("Lütfen yanıltıcı kapıların üzerindeki yazıları belirtiniz.");
    }

    BinaStore.instance.bolum19 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum20Screen()));
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
            title: "Bölüm-19: Kaçış Yolu",
            subtitle: "Engeller ve yönlendirme analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Engeller (Çoklu Seçim)
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Yangın merdivenine giden koridorlarda veya merdiven kapılarında aşağıdakilerden hangisi var?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...[
                          Bolum19Content.engelOptionA, 
                          Bolum19Content.engelOptionB, 
                          Bolum19Content.engelOptionC, 
                          Bolum19Content.engelOptionD
                        ].map((opt) => SelectableCard(
                          choice: opt,
                          isSelected: _model.engeller.any((e) => e.label == opt.label),
                          onTap: () => _handleEngelSelection(opt),
                        )),
                      ],
                    ),
                  ),

                  // 2. Levhalar
                  _buildSoru(
                    "Koridorlarda, ledli veya ışıklı 'ÇIKIŞ' ve koşan adam figürleri asılı mı?", 
                    'levha', 
                    [Bolum19Content.levhaOptionA, Bolum19Content.levhaOptionB, Bolum19Content.levhaOptionC], 
                    _model.levha
                  ),

                  // 3. Yanıltıcı Kapılar
                  _buildSoru(
                    "Koridorda, yangın merdiveni kapısına benzeyen ama aslında depo, elektrik odası veya çöp odası olan kapılar var mı?", 
                    'yaniltici', 
                    [Bolum19Content.yanilticiOptionA, Bolum19Content.yanilticiOptionB], 
                    _model.yanilticiKapi
                  ),

                  // Alt Soru ve Bilgi Notu
                  if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label) ...[
                    _buildInfoNote("Yanıltıcı kapılar tespit edildiği için etiketleme durumu sorgulanmaktadır."),
                    _buildSoru(
                      "Bu kapıların üzerinde hangi mahale ait oldukları yazıyor mu?", 
                      'etiket', 
                      [
                        Bolum19Content.etiketOptionA, 
                        Bolum19Content.etiketOptionB, 
                        Bolum19Content.etiketOptionC
                      ], 
                      _model.yanilticiEtiket
                    ),
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

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 13),
            ),
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
            onPressed: _onNextPressed,
            child: const Text("DEVAM ET"),
          ),
        ),
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