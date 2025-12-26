import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_22_model.dart';
import 'bolum_23_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';

class Bolum22Screen extends StatefulWidget {
  const Bolum22Screen({super.key});

  @override
  State<Bolum22Screen> createState() => _Bolum22ScreenState();
}

class _Bolum22ScreenState extends State<Bolum22Screen> {
  Bolum22Model _model = Bolum22Model();

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        // Eğer "Yok" seçilirse diğer cevapları temizle
        if (choice.label != Bolum22Content.varlikOptionB.label) {
          _model = _model.copyWith(
            konum: null, boyut: null, kabin: null, enerji: null, basinc: null
          );
        }
      } else if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
      } else if (type == 'boyut') {
        _model = _model.copyWith(boyut: choice);
      } else if (type == 'kabin') {
        _model = _model.copyWith(kabin: choice);
      } else if (type == 'enerji') {
        _model = _model.copyWith(enerji: choice);
      } else if (type == 'basinc') {
        _model = _model.copyWith(basinc: choice);
      }
    });
  }

  void _onNextPressed() {
    if (_model.varlik == null) return _showError("Lütfen itfaiye asansörü varlığı sorusunu yanıtlayınız.");

    // Eğer İtfaiye Asansörü varsa (Option B), diğer sorular da zorunlu
    if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) {
      if (_model.konum == null) return _showError("Lütfen asansör kapı konumu sorusunu yanıtlayınız.");
      if (_model.boyut == null) return _showError("Lütfen YGH alan büyüklüğü sorusunu yanıtlayınız.");
      if (_model.kabin == null) return _showError("Lütfen kabin özelliği sorusunu yanıtlayınız.");
      if (_model.enerji == null) return _showError("Lütfen jeneratör bağlantısı sorusunu yanıtlayınız.");
      if (_model.basinc == null) return _showError("Lütfen kuyu basınçlandırma sorusunu yanıtlayınız.");
    }

    BinaStore.instance.bolum22 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum23Screen()),
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
            title: "Bölüm-22: İtfaiye (Acil Durum) Asansörü",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // 1. Varlık Sorusu
                  _buildSoru("Binanızda (51.50m üzeri ise zorunlu olan) İtfaiye (acil durum) asansörü var mı?", 'varlik', 
                    [
                      Bolum22Content.varlikOptionA, 
                      Bolum22Content.varlikOptionB,
                      Bolum22Content.varlikOptionC
                    ], _model.varlik),

                  // Diğer sorular SADECE İTFAİYE ASANSÖRÜ VARSA gösterilir
                  if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) ...[
                    const Divider(height: 30),
                    
                    // 2. Kapı Konumu
                    _buildSoru("Bu İtfaiye (acil durum) asansörünün kapısı nereye açılıyor?", 'konum', 
                      [
                        Bolum22Content.konumOptionA, 
                        Bolum22Content.konumOptionB,
                        Bolum22Content.konumOptionC
                      ], _model.konum),

                    // 3. YGH Boyutu
                    _buildSoru("İtfaiye asansörünün açıldığı YGH'nin taban alanı yaklaşık kaç metrekaredir?", 'boyut', 
                      [
                        Bolum22Content.boyutOptionA, 
                        Bolum22Content.boyutOptionB,
                        Bolum22Content.boyutOptionC,
                        Bolum22Content.boyutOptionD
                      ], _model.boyut),

                    // 4. Kabin Özelliği
                    _buildSoru("Kabin genişliği (en az 1.8 m²) ve hızı yeterli mi?", 'kabin', 
                      [
                        Bolum22Content.kabinOptionA, 
                        Bolum22Content.kabinOptionB,
                        Bolum22Content.kabinOptionC
                      ], _model.kabin),

                    // 5. Enerji / Jeneratör
                    _buildSoru("Bu asansör, elektrik kesildiğinde en az 60 dk çalışabilen bir jeneratöre bağlı mı?", 'enerji', 
                      [
                        Bolum22Content.enerjiOptionA, 
                        Bolum22Content.enerjiOptionB,
                        Bolum22Content.enerjiOptionC
                      ], _model.enerji),

                    // 6. Basınçlandırma
                    _buildSoru("İtfaiye asansörünün kuyusu basınçlandırılmış mı? (İçeriden dışarıya hava üflüyor mu?)", 'basinc', 
                      [
                        Bolum22Content.basincOptionA, 
                        Bolum22Content.basincOptionB,
                        Bolum22Content.basincOptionC
                      ], _model.basinc),
                  ],
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
          )),
        ],
      ),
    );
  }
}