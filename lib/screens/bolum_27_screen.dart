import 'package:flutter/material.dart';
import 'dart:math' as math; // Max değeri bulmak için
import '../../data/bina_store.dart';
import '../../models/bolum_27_model.dart';
import 'bolum_28_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum27Screen extends StatefulWidget {
  const Bolum27Screen({super.key});

  @override
  State<Bolum27Screen> createState() => _Bolum27ScreenState();
}

class _Bolum27ScreenState extends State<Bolum27Screen> {
  Bolum27Model _model = Bolum27Model();
  final ScrollController _scrollController = ScrollController();

  // Logic Değişkenleri
  bool _needsFireDoor = false; // Yangın kapısı zorunlu mu?
  double _maxUserLoad = 0; // En yoğun kattaki kullanıcı sayısı

  @override
  void initState() {
    super.initState();
    _loadLogicData();
  }

  void _loadLogicData() {
    // 1. ADIM: Merdiven Tiplerini Kontrol Et (Bölüm 20 Modelinden)
    final b20 = BinaStore.instance.bolum20;
    
    // Normal merdiven dışındaki tüm "özel" kaçış yollarını topluyoruz.
    // Eğer bunlardan en az 1 tane varsa, orada mutlaka YANGIN KAPISI olmak zorundadır.
    int fireStairsCount = 0;
    if (b20 != null) {
      fireStairsCount += b20.binaIciYanginMerdiveniSayisi;
      fireStairsCount += b20.binaDisiKapaliYanginMerdiveniSayisi;
      fireStairsCount += b20.binaDisiAcikYanginMerdiveniSayisi;
      fireStairsCount += b20.donerMerdivenSayisi;
      fireStairsCount += b20.sahanliksizMerdivenSayisi;
    }

    // Eğer özel kaçış merdiveni varsa yangın kapısı sorusu sorulacak.
    bool needsFireDoor = fireStairsCount > 0;

    // 2. ADIM: Kullanıcı Yükünü Çek (Bölüm 33 Modelinden)
    // En kalabalık katı buluyoruz ki "Panik Bar" uyarısını ona göre verelim.
    final b33 = BinaStore.instance.bolum33;
    double maxLoad = 0;
    
    if (b33 != null) {
      double z = b33.yukZemin ?? 0;
      double n = b33.yukNormal ?? 0;
      double b = b33.yukBodrum ?? 0;
      // En büyük değeri al
      maxLoad = math.max(z, math.max(n, b));
    }

    setState(() {
      _needsFireDoor = needsFireDoor;
      _maxUserLoad = maxLoad;
    });
  }


  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'boyut') _model = _model.copyWith(boyut: choice);
      
      if (type == 'yon') {
        _model = _model.copyWith(yon: choice);
        // 50 Kişi Kontrolü
        if (_maxUserLoad > 50 && choice.label == Bolum27Content.yonOptionB.label) {
          _showWarning("⚠️ DİKKAT: Hesaplanan kullanıcı yükü 50 kişiyi aştığı için kapıların dışarı (kaçış yönüne) açılması zorunludur!");
        }
      }
      
      if (type == 'kilit') {
        _model = _model.copyWith(kilit: choice);
        // 100 Kişi Kontrolü
        if (_maxUserLoad > 100 && choice.label == Bolum27Content.kilitOptionB.label) {
          _showWarning("⚠️ DİKKAT: Hesaplanan kullanıcı yükü 100 kişiyi aştığı için kapı kolu yerine PANİK BAR zorunludur!");
        }
      }
      
      if (type == 'dayanim') _model = _model.copyWith(dayanim: choice);
    });
  }

  void _onNextPressed() {
    if (_model.boyut == null) return _showError("Lütfen kapı genişliği sorusunu yanıtlayınız.");
    if (_model.yon == null) return _showError("Lütfen kapı açılış yönünü seçiniz.");
    if (_model.kilit == null) return _showError("Lütfen kilit mekanizmasını seçiniz.");
    
    // Eğer yangın merdiveni varsa dayanım sorusu zorunludur
    if (_needsFireDoor && _model.dayanim == null) {
      return _showError("Lütfen kapı dayanımı sorusunu yanıtlayınız.");
    }

    BinaStore.instance.bolum27 = _model;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum28Screen()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void _showWarning(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(color: Colors.white)), 
      backgroundColor: Colors.orange[900], 
      duration: const Duration(seconds: 5)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-27: Kaçış Yolu Kapıları",
            subtitle: "Kapıların yön, kilit ve dayanım analizi",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // EN ZAYIF HALKA UYARISI
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Binanızdaki tüm kaçış kapılarını düşünün. Lütfen durumu en kötü (en dar, kilitli veya eski) olan kapıyı baz alarak cevap veriniz.",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 1. BOYUT
                  _buildSoru("Kaçış kapılarının genişliği ve zemini nasıldır?", 'boyut', 
                    [Bolum27Content.boyutOptionA, Bolum27Content.boyutOptionB, Bolum27Content.boyutOptionC], _model.boyut),

                  // 2. YÖN
                  _buildSoru("Kaçış kapıları hangi yöne açılıyor?", 'yon', 
                    [Bolum27Content.yonOptionA, Bolum27Content.yonOptionB, Bolum27Content.yonOptionC, Bolum27Content.yonOptionD], _model.yon),

                  // 3. KİLİT
                  _buildSoru("Kapı kilit mekanizması nasıldır?", 'kilit', 
                    [Bolum27Content.kilitOptionA, Bolum27Content.kilitOptionB, Bolum27Content.kilitOptionC, Bolum27Content.kilitOptionD], _model.kilit),

                  // 4. DAYANIM (Sadece Yangın Merdiveni varsa görünür)
                  if (_needsFireDoor) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(thickness: 2),
                    ),
                    _buildInfoNote("Binanızda Yangın Merdiveni tespit edildiği için aşağıdaki soru zorunludur:"),
                    _buildSoru("Yangın merdiveni kapısının malzemesi nedir?", 'dayanim', 
                      [Bolum27Content.dayanimOptionA, Bolum27Content.dayanimOptionB, Bolum27Content.dayanimOptionC, Bolum27Content.dayanimOptionD], _model.dayanim),
                  ] else ...[
                     const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(thickness: 1),
                    ),
                    const Center(
                      child: Text(
                        "Binanızda sadece Normal Merdiven beyan edildiği için\nYangın Kapısı Dayanım sorusu gizlenmiştir.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                    const SizedBox(height: 20),
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
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.bold, fontSize: 13))),
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