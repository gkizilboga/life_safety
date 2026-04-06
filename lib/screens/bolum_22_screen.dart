import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_22_model.dart';
import 'bolum_23_screen.dart';
import 'bolum_24_screen.dart'; // Atlama için gerekli
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';

class Bolum22Screen extends StatefulWidget {
  const Bolum22Screen({super.key});

  @override
  State<Bolum22Screen> createState() => _Bolum22ScreenState();
}

class _Bolum22ScreenState extends State<Bolum22Screen> {
  Bolum22Model _model = Bolum22Model();
  bool _isMandatory = false;
  double _currentHeight = 0.0;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum22 != null) {
      _model = BinaStore.instance.bolum22!;
    }

    // AKILLI ATLAMA MANTIĞI
    final b7 = BinaStore.instance.bolum7;
    // Eğer Bölüm 7'de normal asansör "Yok" (false) işaretlendiyse burayı atla
    if (b7 != null && b7.hasAsansor == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Bolum24Screen(),
          ), // 23'ü de atlar çünkü o da asansörle ilgili
        );
      });
    } else {
      _checkHeight();
    }
  }

  void _checkHeight() {
    _currentHeight = BinaStore.instance.bolum3?.hYapi ?? 0.0;
    setState(() {
      _isMandatory = _currentHeight >= 51.50;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'varlik') {
        _model = _model.copyWith(varlik: choice);
        if (choice.label != Bolum22Content.varlikOptionB.label) {
          _model = _model.copyWith(
            konum: null,
            boyut: null,
            kabin: null,
            enerji: null,
            basinc: null,
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

  bool _isReady() {
    if (_model.varlik == null) return false;
    if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) {
      return _model.konum != null &&
          _model.boyut != null &&
          _model.kabin != null &&
          _model.enerji != null &&
          _model.basinc != null;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Eğer asansör yoksa boş ekran göster (Zaten initState hemen yönlendirecek)
    final b7 = BinaStore.instance.bolum7;
    if (b7 != null && b7.hasAsansor == false) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnalysisPageLayout(
      title: "İtfaiye (Acil Durum) Asansörü",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum22 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum23Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeightInfoCard(),

          _buildSoru(
            "Binanızda itfaiye asansörü var mı?",
            'varlik',
            [
              Bolum22Content.varlikOptionA,
              Bolum22Content.varlikOptionB,
              Bolum22Content.varlikOptionC,
            ],
            _model.varlik,
            assetPath: AppAssets.section22ItfaiyeHol,
            assetTitle: "İtfaiye asansörü ve hol uygulama detayı",
          ),

          if (_model.varlik?.label == Bolum22Content.varlikOptionB.label) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFECEFF1)),
            ),

            _buildSoru(
              "Bu itfaiye asansörünün kapısı nereye açılıyor?",
              'konum',
              [
                Bolum22Content.konumOptionA,
                Bolum22Content.konumOptionB,
                Bolum22Content.konumOptionC,
              ],
              _model.konum,
            ),

            _buildSoru(
              "İtfaiye asansörünün açıldığı yangın güvenlik holünün taban alanı kaç metrekaredir?",
              'boyut',
              [
                Bolum22Content.boyutOptionA,
                Bolum22Content.boyutOptionB,
                Bolum22Content.boyutOptionC,
                Bolum22Content.boyutOptionD,
              ],
              _model.boyut,
            ),

            _buildSoru(
              "Kabin genişliği en az 1.8 metrekare VE en alt kattan en üst kata 60 saniye içerisinde çıkabiliyor mu?",
              'kabin',
              [
                Bolum22Content.kabinOptionA,
                Bolum22Content.kabinOptionB,
                Bolum22Content.kabinOptionC,
              ],
              _model.kabin,
              assetPath: AppAssets.section22ItfaiyeKabin,
              assetTitle: "İtfaiye asansörü kabin ölçüleri",
            ),

            _buildSoru(
              "Bu asansör, elektrik kesildiğinde en az 60 dakika çalışabilen bir jeneratöre bağlı mı?",
              'enerji',
              [
                Bolum22Content.enerjiOptionA,
                Bolum22Content.enerjiOptionB,
                Bolum22Content.enerjiOptionC,
              ],
              _model.enerji,
            ),

            _buildSoru(
              "İtfaiye asansörünün kuyusu basınçlandırılmış mı?",
              'basinc',
              [
                Bolum22Content.basincOptionA,
                Bolum22Content.basincOptionB,
                Bolum22Content.basincOptionC,
              ],
              _model.basinc,
              assetPath: AppAssets.section22Basinclandirma,
              assetTitle: "Asansör kuyusu basınçlandırma sistemi",
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeightInfoCard() {
    return CustomInfoNote(
      type: _isMandatory ? InfoNoteType.warning : InfoNoteType.info,
      text: _isMandatory
          ? "Yapı yüksekliğiniz $_currentHeight m olduğu için İtfaiye Asansörü ZORUNLUDUR."
          : "Yapı yüksekliğiniz $_currentHeight m (51.50 m altı) olduğu için İtfaiye Asansörü zorunlu değildir. Ancak asansör varlığı denetlenmektedir.",
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
    String? description,
    String? assetPath,
    String? assetTitle,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (assetPath != null)
            QuestionHeaderWithImage(
              questionText: title,
              imageAssetPath: assetPath,
              imageTitle: assetTitle ?? "İtfaiye asansörü detayı",
            )
          else
            Text(title, style: AppStyles.questionTitle),

          if (description != null) ...[
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
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
}
