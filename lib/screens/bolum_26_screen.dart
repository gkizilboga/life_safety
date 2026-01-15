import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_26_model.dart';
import 'bolum_27_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum26Screen extends StatefulWidget {
  const Bolum26Screen({super.key});

  @override
  State<Bolum26Screen> createState() => _Bolum26ScreenState();
}

class _Bolum26ScreenState extends State<Bolum26Screen> {
  Bolum26Model _model = Bolum26Model();
  bool _askOtopark = false;

  // Nokta atışı kaydırma için anahtarlar
  final GlobalKey _egimKey = GlobalKey();
  final GlobalKey _sahanlikKey = GlobalKey();
  final GlobalKey _otoparkKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Bölüm 6'daki otopark varlığına göre şalteri ayarla
    final b6 = BinaStore.instance.bolum6;
    if (b6?.hasOtopark == true) {
      _askOtopark = true;
    }
  }

  // Belirli bir widget'a yumuşak kaydırma fonksiyonu
  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1, // Ekranın üst kısmında durmasını sağlar
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        if (choice.label == Bolum26Content.varlikOptionB.label) {
          _scrollToKey(_egimKey); // Rampa varsa eğim sorusuna kaydır
        } else {
          _model = _model.copyWith(egim: null, sahanlik: null);
          if (_askOtopark)
            _scrollToKey(
              _otoparkKey,
            ); // Rampa yok ama otopark varsa oraya kaydır
        }
      } else if (type == 'egim') {
        _model = _model.copyWith(egim: choice);
        _scrollToKey(_sahanlikKey); // Eğim seçilince sahanlığa kaydır
      } else if (type == 'sahanlik') {
        _model = _model.copyWith(sahanlik: choice);
        if (_askOtopark)
          _scrollToKey(
            _otoparkKey,
          ); // Sahanlık bitince otopark varsa oraya kaydır
      } else if (type == 'otopark') {
        _model = _model.copyWith(otopark: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.varlik == null) return false;
    if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) {
      if (_model.egim == null || _model.sahanlik == null) return false;
    }
    if (_askOtopark && _model.otopark == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kaçış Rampaları",
      subtitle: "Rampa eğimi ve sahanlık",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum26 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum27Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SORU 1: VARLIK ---
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Binada kullanmak zorunda kaldığınız eğimli bir rampa var mı?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),
          ),

          TechnicalDrawingButton(
            assetPath: AppAssets.section26Rampa,
            title: "Kaçış Rampası Örneği",
          ),

          const SizedBox(height: 8),

          QuestionCard(
            child: Column(
              children: [
                SelectableCard(
                  choice: Bolum26Content.varlikOptionA,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionA.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionA),
                ),
                SelectableCard(
                  choice: Bolum26Content.varlikOptionB,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionB.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionB),
                ),
                SelectableCard(
                  choice: Bolum26Content.varlikOptionC,
                  isSelected:
                      _model.varlik?.label ==
                      Bolum26Content.varlikOptionC.label,
                  onTap: () =>
                      _handleSelection('varlik', Bolum26Content.varlikOptionC),
                ),
              ],
            ),
          ),

          // --- ALT SORULAR (Rampa Varsa) ---
          if (_model.varlik?.label == Bolum26Content.varlikOptionB.label) ...[
            _buildInfoNote(
              "Rampa tespit edildiği için eğim ve sahanlık soruları açılmıştır.",
            ),

            // EĞİM SORUSU (Key buraya bağlandı)
            SizedBox(key: _egimKey, height: 1),
            _buildSoru("Bu rampanın eğimi ve zemin kaplaması nasıl?", 'egim', [
              Bolum26Content.egimOptionA,
              Bolum26Content.egimOptionB,
              Bolum26Content.egimOptionC,
            ], _model.egim),

            // SAHANLIK SORUSU (Key buraya bağlandı)
            SizedBox(key: _sahanlikKey, height: 1),
            _buildSoru(
              "Rampanın başlangıcında ve bitişinde sahanlık (düzlük) var mı?",
              'sahanlik',
              [
                Bolum26Content.sahanlikOptionA,
                Bolum26Content.sahanlikOptionB,
                Bolum26Content.sahanlikOptionC,
              ],
              _model.sahanlik,
            ),
          ],

          // --- OTOPARK RAMPASI (Sadece Otopark Varsa) ---
          if (_askOtopark) ...[
            // OTOPARK SORUSU (Key buraya bağlandı)
            SizedBox(key: _otoparkKey, height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                "Otopark Araç Rampası",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238),
                ),
              ),
            ),
            _buildSoru(
              "Otopark araç rampasını acil durumda kaçış yolu olarak kullanabilir misiniz?",
              'otopark',
              [
                Bolum26Content.otoparkOptionA,
                Bolum26Content.otoparkOptionB,
                Bolum26Content.otoparkOptionC,
              ],
              _model.otopark,
            ),
          ],
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),
          const SizedBox(height: 12),
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

  Widget _buildInfoNote(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Color(0xFFE65100), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
