import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_25_model.dart';
import 'bolum_26_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_assets.dart';

class Bolum25Screen extends StatefulWidget {
  const Bolum25Screen({super.key});

  @override
  State<Bolum25Screen> createState() => _Bolum25ScreenState();
}

class _Bolum25ScreenState extends State<Bolum25Screen> {
  Bolum25Model _model = Bolum25Model();
  bool _isCommercial = false;

  @override
  void initState() {
    super.initState();
    _checkLogicAndRedirect();
  }

  void _checkLogicAndRedirect() {
    final b20 = BinaStore.instance.bolum20;
    final b6 = BinaStore.instance.bolum6;
    final b10 = BinaStore.instance.bolum10;

    int donerCount = b20?.donerMerdivenSayisi ?? 0;

    if (donerCount == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bolum26Screen()),
        );
      });
    }

    bool hasTicari = (b6?.hasTicari ?? false) ||
        (b10?.zemin?.label.contains("Ticari") ?? false) ||
        (b10?.bodrumlar.any((e) => e?.label.contains("Ticari") ?? false) ?? false) ||
        (b10?.normaller.any((e) => e?.label.contains("Ticari") ?? false) ?? false);

    setState(() {
      _isCommercial = hasTicari;
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'kapasite') _model = _model.copyWith(kapasite: choice);
      if (type == 'basamak') _model = _model.copyWith(basamak: choice);
      if (type == 'basKurtarma') _model = _model.copyWith(basKurtarma: choice);
    });
  }

  bool _isReady() {
    return _model.kapasite != null && _model.basamak != null && _model.basKurtarma != null;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Döner Merdiven Analizi",
      subtitle: "Dairesel merdivenlerin tahliye uygunluğu",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum25 = _model;
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum26Screen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isCommercial) _buildCommercialWarning(),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Dairesel merdiven teknik ölçümleri:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF263238)),
            ),
          ),
          const SizedBox(height: 8),
          _buildSoru(
            "1. Merdiven kol genişliği ve hizmet verdiği kişi sayısı nedir?",
            'kapasite',
            [Bolum25Content.kapasiteOptionA, Bolum25Content.kapasiteOptionB, Bolum25Content.kapasiteOptionC],
            _model.kapasite,
          ),
          _buildSoru(
            "2. Basamak genişliği (basış yüzeyi) yeterli mi?",
            'basamak',
            [Bolum25Content.basamakOptionA, Bolum25Content.basamakOptionB, Bolum25Content.basamakOptionC],
            _model.basamak,
          ),
          _buildSoru(
            "3. Baş kurtarma yüksekliği ne kadardır?",
            'basKurtarma',
            [Bolum25Content.basKurtarmaOptionA, Bolum25Content.basKurtarmaOptionB, Bolum25Content.basKurtarmaOptionC],
            _model.basKurtarma,
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF9A9A)),
      ),
      child: const Row(
        children: [
          Icon(Icons.gavel_rounded, color: Color(0xFFC62828), size: 28),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "YÖNETMELİK KISITLAMASI: Binada ticari alan bulunduğu için döner merdivenler kaçış yolu olarak kabul edilemez. Lütfen teknik ölçümleri yine de yapınız.",
              style: TextStyle(color: Color(0xFFB71C1C), fontSize: 12, fontWeight: FontWeight.bold),
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
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
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