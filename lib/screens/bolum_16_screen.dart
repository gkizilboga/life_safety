import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_16_model.dart';
import 'bolum_17_screen.dart'; 
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum16Screen extends StatefulWidget {
  const Bolum16Screen({super.key});

  @override
  State<Bolum16Screen> createState() => _Bolum16ScreenState();
}

class _Bolum16ScreenState extends State<Bolum16Screen> {
  Bolum16Model _model = Bolum16Model();
  bool _askBitisik = false;

  @override
  void initState() {
    super.initState();
    final b8 = BinaStore.instance.bolum8;
    if (b8?.secim?.label.contains("Bitişik") == true || b8?.secim?.label == "8-1-B") {
      _askBitisik = true;
    }
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'mantolama') {
        _model = _model.copyWith(mantolama: choice);
        if (choice.label != Bolum16Content.giydirmeOptionC.label) {
          _model = _model.copyWith(giydirmeBoslukYalitim: null);
        }
      }
      if (type == 'sagir') {
        _model = _model.copyWith(sagirYuzey: choice);
        if (choice.label != Bolum16Content.sagirYuzeyOptionB.label) {
          _model = _model.copyWith(sagirYuzeySprinkler: null);
        }
      }
      if (type == 'bitisik') _model = _model.copyWith(bitisikNizam: choice);
    });
  }

  bool _isReady() {
    if (_model.mantolama == null) return false;
    if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label && _model.giydirmeBoslukYalitim == null) return false;
    if (_model.sagirYuzey == null) return false;
    if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label && _model.sagirYuzeySprinkler == null) return false;
    if (_askBitisik && _model.bitisikNizam == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dış Cephe Özellikleri",
      subtitle: "Cephe malzemesi ve yangın sıçrama analizi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum16 = _model;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum17Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- ADIM 1: CEPHE MALZEMESİ ---
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text("1. Binanızın dış cephesinde kullanılan kaplama veya ısı yalıtım sistemi nedir?", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          ),
          QuestionCard(
            child: Column(
              children: [
                // Şık A + Görsel
                SelectableCard(
                  choice: Bolum16Content.mantolamaOptionA,
                  isSelected: _model.mantolama?.label == Bolum16Content.mantolamaOptionA.label,
                  onTap: () => _handleSelection('mantolama', Bolum16Content.mantolamaOptionA),
                ),
                TechnicalDrawingButton(assetPath: AppAssets.section16XpsMantolama, title: "EPS/XPS Mantolama Detayı"),
                const SizedBox(height: 8),

                // Şık B + Görsel
                SelectableCard(
                  choice: Bolum16Content.mantolamaOptionB,
                  isSelected: _model.mantolama?.label == Bolum16Content.mantolamaOptionB.label,
                  onTap: () => _handleSelection('mantolama', Bolum16Content.mantolamaOptionB),
                ),
                TechnicalDrawingButton(assetPath: AppAssets.section16TasyunuMantolama, title: "Taşyünü (Yanmaz) Mantolama Detayı"),
                const SizedBox(height: 8),

                // Şık C + Görsel
                SelectableCard(
                  choice: Bolum16Content.giydirmeOptionC,
                  isSelected: _model.mantolama?.label == Bolum16Content.giydirmeOptionC.label,
                  onTap: () => _handleSelection('mantolama', Bolum16Content.giydirmeOptionC),
                ),
                TechnicalDrawingButton(assetPath: AppAssets.section16Giydirme, title: "Giydirme Cephe ve Kat Arası Yalıtım"),
                
                // Giydirme Alt Soru
                if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label) 
                  _buildSubQuestion(
                    "Cephe ile döşeme arasındaki boşluklar yangına dayanıklı malzeme ile kapatılmış mı?",
                    _model.giydirmeBoslukYalitim,
                    (v) => setState(() => _model = _model.copyWith(giydirmeBoslukYalitim: v))
                  ),

                SelectableCard(
                  choice: Bolum16Content.mantolamaOptionD,
                  isSelected: _model.mantolama?.label == Bolum16Content.mantolamaOptionD.label,
                  onTap: () => _handleSelection('mantolama', Bolum16Content.mantolamaOptionD),
                ),
                SelectableCard(
                  choice: Bolum16Content.mantolamaOptionE,
                  isSelected: _model.mantolama?.label == Bolum16Content.mantolamaOptionE.label,
                  onTap: () => _handleSelection('mantolama', Bolum16Content.mantolamaOptionE),
                ),
              ],
            ),
          ),

          // --- ADIM 2: SAĞIR YÜZEY ---
          const Padding(
            padding: EdgeInsets.only(left: 4, top: 12, bottom: 12),
            child: Text("2. Katlar arasındaki dolu duvar (sağır yüzey) yüksekliği ne kadar?", 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          ),
          TechnicalDrawingButton(assetPath: AppAssets.section16Spandrel, title: "Katlar Arası Yangın Geçişi (Spandrel) Kriteri"),
          QuestionCard(
            child: Column(
              children: [
                SelectableCard(
                  choice: Bolum16Content.sagirYuzeyOptionA,
                  isSelected: _model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionA.label,
                  onTap: () => _handleSelection('sagir', Bolum16Content.sagirYuzeyOptionA),
                ),
                SelectableCard(
                  choice: Bolum16Content.sagirYuzeyOptionB,
                  isSelected: _model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label,
                  onTap: () => _handleSelection('sagir', Bolum16Content.sagirYuzeyOptionB),
                ),
                // Sağır Yüzey Alt Soru
                if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label)
                  _buildSubQuestion(
                    "Cepheye bakan özel Sprinkler (Yağmurlama) sistemi var mı?",
                    _model.sagirYuzeySprinkler,
                    (v) => setState(() => _model = _model.copyWith(sagirYuzeySprinkler: v))
                  ),
                SelectableCard(
                  choice: Bolum16Content.sagirYuzeyOptionC,
                  isSelected: _model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionC.label,
                  onTap: () => _handleSelection('sagir', Bolum16Content.sagirYuzeyOptionC),
                ),
              ],
            ),
          ),

          // --- ADIM 3: BİTİŞİK NİZAM ---
          if (_askBitisik) ...[
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 12, bottom: 12),
              child: Text("3. Binanız bitişik nizamda ve yan binadan daha yüksek mi?", 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
            ),
            TechnicalDrawingButton(assetPath: AppAssets.section16Sicrama, title: "Yan Binadan Yangın Sıçrama Riski"),
            QuestionCard(
              child: Column(
                children: [
                  SelectableCard(
                    choice: Bolum16Content.bitisikOptionA,
                    isSelected: _model.bitisikNizam?.label == Bolum16Content.bitisikOptionA.label,
                    onTap: () => _handleSelection('bitisik', Bolum16Content.bitisikOptionA),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.bitisikOptionB,
                    isSelected: _model.bitisikNizam?.label == Bolum16Content.bitisikOptionB.label,
                    onTap: () => _handleSelection('bitisik', Bolum16Content.bitisikOptionB),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.bitisikOptionC,
                    isSelected: _model.bitisikNizam?.label == Bolum16Content.bitisikOptionC.label,
                    onTap: () => _handleSelection('bitisik', Bolum16Content.bitisikOptionC),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubQuestion(String title, bool? groupValue, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF455A64))),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<bool>(value: true, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Evet", style: TextStyle(fontSize: 14)),
              const SizedBox(width: 20),
              Radio<bool>(value: false, groupValue: groupValue, activeColor: const Color(0xFF1A237E), onChanged: onChanged),
              const Text("Hayır", style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}