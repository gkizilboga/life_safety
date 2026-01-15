import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_36_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import 'report_summary_screen.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';
import '../../utils/app_theme.dart';

class Bolum36Screen extends StatefulWidget {
  const Bolum36Screen({super.key});
  @override
  State<Bolum36Screen> createState() => _Bolum36ScreenState();
}

class _Bolum36ScreenState extends State<Bolum36Screen> {
  Bolum36Model _model = Bolum36Model();

  final _genislikKorunumluCtrl = TextEditingController();
  final _genislikKorunumsuzCtrl = TextEditingController();
  final _kapiGenislikKorunumluCtrl = TextEditingController();
  final _kapiGenislikKorunumsuzCtrl = TextEditingController();

  final GlobalKey _konumKey = GlobalKey();
  final GlobalKey _genislikKey = GlobalKey();
  final GlobalKey _kapiKey = GlobalKey();
  final GlobalKey _gorunurlukKey = GlobalKey();

  bool _genislikBilinmiyor = false;
  bool _kapiGenislikBilinmiyor = false;

  int _cntDisCelik = 0;
  int _totalValidCikisSayisi = 0;
  bool _hasKorunumlu = false;
  bool _hasKorunumsuz = false;

  @override
  void initState() {
    super.initState();
    final b20 = BinaStore.instance.bolum20;

    int icKapali = b20?.binaIciYanginMerdiveniSayisi ?? 0;
    int disKapali = b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0;
    int normal = b20?.normalMerdivenSayisi ?? 0;
    int doner = b20?.donerMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;

    _cntDisCelik = disAcik;
    _totalValidCikisSayisi = icKapali + disKapali + normal + doner + disAcik;

    _hasKorunumlu = (icKapali + disKapali) > 0;
    _hasKorunumsuz = (normal + doner + disAcik + sahanliksiz) > 0;
  }

  void _scrollToKey(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (key.currentContext != null)
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
    });
  }

  @override
  void dispose() {
    _genislikKorunumluCtrl.dispose();
    _genislikKorunumsuzCtrl.dispose();
    _kapiGenislikKorunumluCtrl.dispose();
    _kapiGenislikKorunumsuzCtrl.dispose();
    super.dispose();
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'cikisKati') _model = _model.copyWith(cikisKati: choice);
      if (type == 'disMerd') {
        _model = _model.copyWith(disMerd: choice);
        _scrollToKey(_konumKey);
      }
      if (type == 'konum') {
        _model = _model.copyWith(konum: choice);
        _scrollToKey(_genislikKey);
      }
      if (type == 'kapiTipi') {
        _model = _model.copyWith(kapiTipi: choice);
        _scrollToKey(_kapiKey);
      }
      if (type == 'gorunurluk') _model = _model.copyWith(gorunurluk: choice);
    });
  }

  String _evaluateStairsAndExits() {
    final store = BinaStore.instance;
    final b4 = store.bolum4;
    final b20 = store.bolum20;
    final b33 = store.bolum33;
    double hBina = b4?.hesaplananBinaYuksekligi ?? 0.0;
    double hYapi = b4?.hesaplananYapiYuksekligi ?? 0.0;
    int korunumlu =
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0);
    int sahanliksiz = b20?.sahanliksizMerdivenSayisi ?? 0;
    int doner = b20?.donerMerdivenSayisi ?? 0;
    int disAcik = b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0;
    bool basinclandirmaVar = b20?.basinclandirma?.label == "20-BAS-A";
    List<String> notes = [];
    if (sahanliksiz > 0)
      notes.add(
        "Binada 'Sahanlıksız Merdiven' tespit edilmiştir. Bu merdiven tipi hiçbir binada kaçış yolu olarak kabul edilemez. YENİ BİNA 'larda tüm merdiven tiplerinde insanların tahliye esnasında dinlenebileceği sahanlıkların bulunması Yönetmeliğe göre zorunludur.",
      );
    if (hBina > 9.50 && doner > 0)
      notes.add(
        "Bina yüksekliği 9.50m üzerinde olduğu için 'Dairesel Merdiven' kullanımı yasaktır. Dairesel merdiven ile özel çözüm gereken katlar varsa Uzman görüşü alınarak ilerlenmesi önerilir.",
      );
    if (hBina > 21.50 && disAcik > 0)
      notes.add(
        "Bina yüksekliği 21.50m üzerinde olduğu için 'Bina Dışı Açık Çelik Merdiven' kullanımı yasaktır.",
      );
    if (hYapi < 21.50)
      notes.add(
        "Yapı yüksekliği 21.50m altındadır. Sahanlıksız merdiven hariç tüm merdiven tipleri kullanılabilir.",
      );
    else if (hYapi >= 21.50 && hYapi < 30.50) {
      if (korunumlu >= 1)
        notes.add(
          "Yapı yüksekliği 21.50m-30.50m arasındadır ve en az 1 adet korunumlu merdiven mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 21.50m-30.50m arasındadır. En az 1 adet 'Korunumlu Merdiven' zorunludur.",
        );
    } else if (hYapi >= 30.50 && hYapi < 51.50) {
      if (korunumlu >= 2)
        notes.add(
          "Yapı yüksekliği 30.50m-51.50m arasındadır ve en az 2 adet korunumlu merdiven mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 30.50m-51.50m arasındadır. En az 2 adet 'Korunumlu Merdiven' zorunludur.",
        );
    } else if (hYapi >= 51.50) {
      if (korunumlu >= 2)
        notes.add(
          "Yapı yüksekliği 51.50m üzerindedir ve en az 2 adet korunumlu merdiven mevcuttur.",
        );
      else
        notes.add(
          "Yapı yüksekliği 51.50m üzerindedir. En az 2 adet 'Korunumlu Merdiven' zorunludur.",
        );
      if (!basinclandirmaVar)
        notes.add(
          "51.50m üzeri binalarda her iki korunumlu merdivende hem YGH hem de Basınçlandırma Sistemi tesis edilmesi zorunludur.",
        );
    }
    int gerekli = b33?.gerekliNormal ?? 0;
    int mevcut = b33?.mevcutUst ?? 0;
    if (mevcut >= gerekli)
      notes.add(
        "✅ ÇIKIŞ SAYISI YETERLİ: Mevcut çıkış sayısı ($mevcut), gereken çıkış sayısından ($gerekli) fazla olduğundan, çıkış sayısı bakımından yeterli gözükmektedir. Ancak bu durum tek başına yeterli olmayıp, binadaki merdiven tiplerinin ve adedinin kriterleri de uygun olması gereklidir.",
      );
    else
      notes.add(
        "🚨 ÇIKIŞ SAYISI YETERSİZ: Yönetmelik gereği $gerekli çıkış gerekirken, binada sadece $mevcut çıkış bulunmaktadır. Çıkış sayısı bakımından yetersiz gözükmektedir. Bu durumla birlikte binadaki merdiven tiplerinin ve adetlerinin de Yönetmelik kriterlerini karşılaması beklenir.",
      );
    return notes.join("\n\n");
  }

  bool get _isFormValid {
    if (_model.cikisKati == null) return false;
    if (_cntDisCelik > 0 && _model.disMerd == null) return false;
    if (_totalValidCikisSayisi > 1 && _model.konum == null) return false;

    if (!_genislikBilinmiyor) {
      if (_hasKorunumlu && _genislikKorunumluCtrl.text.isEmpty) return false;
      if (_hasKorunumsuz && _genislikKorunumsuzCtrl.text.isEmpty) return false;
    }

    if (_model.kapiTipi == null) return false;

    if (!_kapiGenislikBilinmiyor) {
      if (_hasKorunumlu && _kapiGenislikKorunumluCtrl.text.isEmpty)
        return false;
      if (_hasKorunumsuz && _kapiGenislikKorunumsuzCtrl.text.isEmpty)
        return false;
    }

    if (_model.gorunurluk == null) return false;
    return true;
  }

  void _onFinishPressed() {
    int? genK = _genislikBilinmiyor
        ? null
        : int.tryParse(_genislikKorunumluCtrl.text);
    int? genKS = _genislikBilinmiyor
        ? null
        : int.tryParse(_genislikKorunumsuzCtrl.text);
    int? kGenK = _kapiGenislikBilinmiyor
        ? null
        : int.tryParse(_kapiGenislikKorunumluCtrl.text);
    int? kGenKS = _kapiGenislikBilinmiyor
        ? null
        : int.tryParse(_kapiGenislikKorunumsuzCtrl.text);

    String finalReport = _evaluateStairsAndExits();
    _model = _model.copyWith(
      genislikKorunumlu: genK,
      genislikKorunumsuz: genKS,
      kapiGenislikKorunumlu: kGenK,
      kapiGenislikKorunumsuz: kGenKS,
      merdivenDegerlendirme: finalReport,
    );
    BinaStore.instance.bolum36 = _model;
    BinaStore.instance.saveToDisk();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModuleTransitionScreen(
          module: ReportModule.modul5,
          onContinue: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ReportSummaryScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Merdiven Ölçüleri ve Çıkış Esnasında Güvenlik",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isFormValid,
      onNext: _onFinishPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSoruHeader(
            "Binadan dış havaya (atmosfere) çıktığınız kat hangisidir?",
          ),
          _buildSoruCard('cikisKati', [
            Bolum36Content.cikisKatiOptionA,
            Bolum36Content.cikisKatiOptionB,
            Bolum36Content.cikisKatiOptionC,
          ], _model.cikisKati),
          if (_cntDisCelik > 0) ...[
            _buildSoruHeader(
              "Dışarıdaki yangın merdivenine 3 metre mesafede açıklık var mı?",
            ),
            _buildSoruCard('disMerd', [
              Bolum36Content.disMerdOptionA,
              Bolum36Content.disMerdOptionB,
              Bolum36Content.disMerdOptionC,
            ], _model.disMerd),
          ],
          SizedBox(key: _konumKey, height: 1),
          if (_totalValidCikisSayisi > 1) ...[
            _buildInfoNote(
              "Binada birden fazla çıkış tespit edildiği için konumlarının hususi olarak değerlendirilmesi gereklidir.",
            ),
            _buildSoruHeader(
              "Kaçış merdivenleri birbirine göre nasıl konumlanmış?",
            ),
            _buildSoruCard('konum', [
              Bolum36Content.konumOptionA,
              Bolum36Content.konumOptionB,
              Bolum36Content.konumOptionC,
            ], _model.konum),
          ],
          SizedBox(key: _genislikKey, height: 1),
          _buildSoruHeader("Merdiven/Koridor temiz genişliği (cm) kaçtır?"),
          QuestionCard(
            child: Column(
              children: [
                if (_hasKorunumlu)
                  _buildInput(
                    "Korunumlu (Yangın) Merdiveni Genişliği",
                    _genislikKorunumluCtrl,
                    _genislikBilinmiyor,
                  ),
                if (_hasKorunumsuz)
                  _buildInput(
                    "Korunumsuz (Normal) Merdiven Genişliği",
                    _genislikKorunumsuzCtrl,
                    _genislikBilinmiyor,
                  ),
                const SizedBox(height: 10),
                SelectableCard(
                  choice: Bolum36Content.genislikBilinmiyor,
                  isSelected: _genislikBilinmiyor,
                  onTap: () => setState(() {
                    _genislikBilinmiyor = !_genislikBilinmiyor;
                    if (_genislikBilinmiyor) {
                      _genislikKorunumluCtrl.clear();
                      _genislikKorunumsuzCtrl.clear();
                    }
                    _scrollToKey(_kapiKey);
                  }),
                ),
              ],
            ),
          ),
          _buildSoruHeader("Katınızdaki çıkış kapılarının tipi nedir?"),
          _buildSoruCard('kapiTipi', [
            Bolum36Content.kapiTipiOptionA,
            Bolum36Content.kapiTipiOptionB,
            Bolum36Content.kapiTipiOptionC,
          ], _model.kapiTipi),
          SizedBox(key: _kapiKey, height: 1),
          _buildSoruHeader(
            "Katınızdaki çıkış kapılarının temiz (net geçiş) genişliği kaç santimetredir?",
          ),
          QuestionCard(
            child: Column(
              children: [
                if (_hasKorunumlu)
                  _buildInput(
                    "Korunumlu (Yangın) Merdiven Kapı Genişliği",
                    _kapiGenislikKorunumluCtrl,
                    _kapiGenislikBilinmiyor,
                  ),
                if (_hasKorunumsuz)
                  _buildInput(
                    "Korunumsuz (Normal) Merdiven Kapı Genişliği",
                    _kapiGenislikKorunumsuzCtrl,
                    _kapiGenislikBilinmiyor,
                  ),
                const SizedBox(height: 10),
                SelectableCard(
                  choice: Bolum36Content.kapiGenislikBilinmiyor,
                  isSelected: _kapiGenislikBilinmiyor,
                  onTap: () => setState(() {
                    _kapiGenislikBilinmiyor = !_kapiGenislikBilinmiyor;
                    if (_kapiGenislikBilinmiyor) {
                      _kapiGenislikKorunumluCtrl.clear();
                      _kapiGenislikKorunumsuzCtrl.clear();
                    }
                    _scrollToKey(_gorunurlukKey);
                  }),
                ),
              ],
            ),
          ),
          SizedBox(key: _gorunurlukKey, height: 1),
          _buildSoruHeader("Kaçış yolları açıkça görülebiliyor mu?"),
          _buildSoruCard('gorunurluk', [
            Bolum36Content.gorunurlukOptionA,
            Bolum36Content.gorunurlukOptionB,
            Bolum36Content.gorunurlukOptionC,
          ], _model.gorunurluk),
        ],
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController ctrl,
    bool isDisabled,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        enabled: !isDisabled,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 14),
        decoration: AppStyles.inputDecoration(
          label,
          suffix: "cm",
        ).copyWith(labelText: label, hintText: "Örn: 120"),
      ),
    );
  }

  Widget _buildSoruHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildSoruCard(
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected,
  ) {
    return QuestionCard(
      child: Column(
        children: options
            .map(
              (opt) => SelectableCard(
                choice: opt,
                isSelected: selected?.label == opt.label,
                onTap: () => _handleSelection(key, opt),
              ),
            )
            .toList(),
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
