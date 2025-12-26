import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_30_model.dart';
import 'bolum_31_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum30Screen extends StatefulWidget {
  const Bolum30Screen({super.key});

  @override
  State<Bolum30Screen> createState() => _Bolum30ScreenState();
}

class _Bolum30ScreenState extends State<Bolum30Screen> {
  Bolum30Model _model = Bolum30Model();
  final TextEditingController _kapasiteCtrl = TextEditingController();
  bool _hasKazan = false;

  @override
  void initState() {
    super.initState();
    _checkKazanAndRedirect();
  }

  void _checkKazanAndRedirect() {
    final b7 = BinaStore.instance.bolum7;
    
    if (b7?.hasKazan == true) {
      setState(() {
        _hasKazan = true;
      });
    } else {
      // Kazan dairesi yoksa, ekran çizilir çizilmez bir sonraki bölüme yönlendir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum31Screen()),
        );
      });
    }
  }

  @override
  void dispose() {
    _kapasiteCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'konum') _model = _model.copyWith(konum: choice);
      if (type == 'kapi') _model = _model.copyWith(kapi: choice);
      if (type == 'hava') _model = _model.copyWith(hava: choice);
      if (type == 'tup') _model = _model.copyWith(tup: choice);
      
      if (type == 'yakit') {
        _model = _model.copyWith(yakit: choice);
        // Sıvı yakıt (Option B) dışında bir şey seçilirse drenajı sıfırla
        if (choice.label != Bolum30Content.yakitOptionB.label) {
          _model = _model.copyWith(drenaj: null);
        }
      }
      
      if (type == 'drenaj') _model = _model.copyWith(drenaj: choice);
    });
  }

  void _onNextPressed() {
    if (_hasKazan) {
      // Validasyonlar
      if (_model.konum == null) return _showError("Lütfen kazan dairesi konumunu seçiniz.");
      
      // Kapasiteyi sayısal olarak modele işle
      double? kap = double.tryParse(_kapasiteCtrl.text.replaceAll(',', '.'));
      _model = _model.copyWith(kapasite: kap);

      if (_model.kapi == null) return _showError("Lütfen çıkış kapısı sayısını seçiniz.");
      if (_model.hava == null) return _showError("Lütfen havalandırma durumunu seçiniz.");
      if (_model.yakit == null) return _showError("Lütfen yakıt türünü seçiniz.");

      // Sadece sıvı yakıt seçiliyse drenaj zorunlu
      if (_model.yakit?.label == Bolum30Content.yakitOptionB.label && _model.drenaj == null) {
        return _showError("Lütfen drenaj kanalı durumunu seçiniz.");
      }

      if (_model.tup == null) return _showError("Lütfen yangın söndürme ekipmanı durumunu seçiniz.");
    }

    BinaStore.instance.bolum30 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum31Screen()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kazan dairesi yoksa boş bir yükleniyor ekranı göster (yönlendirme bitene kadar)
    if (!_hasKazan) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-30: Kazan Dairesi / Isı Merkezi",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. KONUM
                  _buildSoru("Kazan dairesinin konumu ve kapısının açıldığı yer nasıl?", 'konum', 
                    [
                      Bolum30Content.konumOptionA, 
                      Bolum30Content.konumOptionB, 
                      Bolum30Content.konumOptionC,
                      Bolum30Content.konumOptionD,
                    ], _model.konum),

                  // 2. KAPASİTE (SAYISAL GİRİŞ)
                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Kazan kapasitesi (kW/kcal) biliniyorsa giriniz (Opsiyonel):", 
                          style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _kapasiteCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: "Örn: 350",
                            suffixText: "kW",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. KAPI SAYISI
                  _buildSoru("Kazan dairesinin kaç adet çıkış kapısı var?", 'kapi', 
                    [
                      Bolum30Content.kapiOptionA, 
                      Bolum30Content.kapiOptionB,
                      Bolum30Content.kapiOptionC,
                    ], _model.kapi),

                  // 4. HAVALANDIRMA
                  _buildSoru("İçeriye temiz hava girmesini ve kirli havanın çıkmasını sağlayan menfezler var mı?", 'hava', 
                    [
                      Bolum30Content.havaOptionA, 
                      Bolum30Content.havaOptionB,
                      Bolum30Content.havaOptionC,
                    ], _model.hava),

                  // 5. YAKIT TİPİ
                  _buildSoru("Kazanınız sıvı yakıtlı (Mazot/Fuel-oil) mı?", 'yakit', 
                    [
                      Bolum30Content.yakitOptionA, 
                      Bolum30Content.yakitOptionB,
                      Bolum30Content.yakitOptionC,
                    ], _model.yakit),

                  // 6. DRENAJ (SADECE SIVI YAKIT İSE)
                  if (_model.yakit?.label == Bolum30Content.yakitOptionB.label) ...[
                    const Divider(height: 30),
                    _buildSoru("Zeminde dökülen yakıtı toplayacak kanallar ve bir pis su çukuru var mı?", 'drenaj', 
                      [
                        Bolum30Content.drenajOptionA, 
                        Bolum30Content.drenajOptionB,
                        Bolum30Content.drenajOptionC,
                      ], _model.drenaj),
                  ],

                  // 7. YANGIN TÜPÜ / SÖNDÜRME
                  _buildSoru("Kazan dairesinde yangın söndürme tüpü ve yangın dolabı var mı?", 'tup', 
                    [
                      Bolum30Content.tupOptionA, 
                      Bolum30Content.tupOptionB, 
                      Bolum30Content.tupOptionC,
                      Bolum30Content.tupOptionD,
                    ], _model.tup),
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

  // Yardımcı Soru Oluşturucu
  Widget _buildSoru(String title, String key, List<ChoiceResult> options, ChoiceResult? selected) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
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