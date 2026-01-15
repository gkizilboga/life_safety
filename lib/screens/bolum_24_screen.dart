import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_24_model.dart';
import 'bolum_25_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum24Screen extends StatefulWidget {
  const Bolum24Screen({super.key});

  @override
  State<Bolum24Screen> createState() => _Bolum24ScreenState();
}

class _Bolum24ScreenState extends State<Bolum24Screen> {
  Bolum24Model _model = Bolum24Model();

  // Nokta atışı kaydırma için anahtarlar (Keys)
  final GlobalKey _q2Key = GlobalKey();
  final GlobalKey _q3Key = GlobalKey();

  // Belirli bir widget'a kaydırma fonksiyonu
  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1, // Ekranın biraz üst kısmında durmasını sağlar
        );
      }
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'tip') {
        _model = _model.copyWith(tip: choice);
        if (choice.label == Bolum24Content.tipOptionB.label) {
          // Soru 1 cevaplanınca Soru 2'ye (veya bilgi notuna) kaydır
          _scrollToKey(_q2Key);
        } else {
          _model = _model.copyWith(pencere: null, kapi: null);
        }
      } else if (type == 'pencere') {
        _model = _model.copyWith(pencere: choice);
        // Soru 2 cevaplanınca Soru 3'e kaydır
        _scrollToKey(_q3Key);
      } else if (type == 'kapi') {
        _model = _model.copyWith(kapi: choice);
      }
    });
  }

  bool _isReady() {
    if (_model.tip == null) return false;
    if (_model.tip?.label == Bolum24Content.tipOptionB.label) {
      return _model.pencere != null && _model.kapi != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dış Kaçış Geçitleri",
      subtitle: "Açık kaçış yollarının güvenlik analizi",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum24 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum25Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SORU 1 ---
          _buildSoru(
            "Daire kapınızdan veya kat koridorlarından bina dışına çıkışınız nasıl?",
            'tip',
            [
              Bolum24Content.tipOptionA,
              Bolum24Content.tipOptionB,
              Bolum24Content.tipOptionC,
            ],
            _model.tip,
            assetPath: AppAssets.section24DisGecit,
            assetTitle: "Dış Kaçış Geçidi Örneği",
          ),

          // Alt Sorular (Sadece Seçenek B ise görünür)
          if (_model.tip?.label == Bolum24Content.tipOptionB.label) ...[
            // SORU 2'NİN ADRESİ (Key buraya bağlandı)
            Padding(
              key: _q2Key,
              padding: const EdgeInsets.only(top: 8),
              child: _buildInfoNote(
                "Açık kaçış yolu tespit edildiği için ek güvenlik soruları açılmıştır.",
              ),
            ),

            _buildSoru(
              "Açık kaçış yoluna bakan dairelere ait pencereler var mı?",
              'pencere',
              [
                Bolum24Content.pencereOptionA,
                Bolum24Content.pencereOptionB,
                Bolum24Content.pencereOptionC,
              ],
              _model.pencere,
            ),

            // SORU 3'ÜN ADRESİ (Key buraya bağlandı)
            SizedBox(key: _q3Key, height: 1),

            _buildSoru(
              "Açık kaçış yoluna açılan daire kapınızın özelliği nedir?",
              'kapi',
              [
                Bolum24Content.kapiOptionA,
                Bolum24Content.kapiOptionB,
                Bolum24Content.kapiOptionC,
              ],
              _model.kapi,
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
    ChoiceResult? selected, {
    String? assetPath,
    String? assetTitle,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),

          if (assetPath != null) ...[
            const SizedBox(height: 12),
            TechnicalDrawingButton(
              assetPath: assetPath,
              title: assetTitle ?? "Teknik Detay",
            ),
          ],

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
