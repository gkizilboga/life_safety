import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_7_model.dart';
import '../../utils/app_theme.dart';
import 'bolum_8_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../utils/app_assets.dart';

class Bolum7Screen extends StatefulWidget {
  const Bolum7Screen({super.key});

  @override
  State<Bolum7Screen> createState() => _Bolum7ScreenState();
}

class _Bolum7ScreenState extends State<Bolum7Screen> {
  Bolum7Model _model = Bolum7Model();
  bool _isConfirmed = false;
  bool _isAutoSelected = false;

  @override
  void initState() {
    super.initState();
    final existing = BinaStore.instance.bolum7;
    if (existing != null) {
      _model = existing;
      _isConfirmed = true;
    } else {
      // First time initialization: check floor count for elevator default
      final b3 = BinaStore.instance.bolum3;
      final totalFloors =
          (b3?.normalKatSayisi ?? 0) + (b3?.bodrumKatSayisi ?? 0) + 1;
      if (totalFloors >= 3) {
        _model = _model.copyWith(hasAsansor: true);
        _isAutoSelected = true;
      }
    }
    _syncWithPreviousSteps();
  }

  void _syncWithPreviousSteps() {
    final b6 = BinaStore.instance.bolum6;
    setState(() {
      _model = _model.copyWith(
        hasOtopark: b6?.hasOtopark ?? false,
        hasDepo: b6?.hasDepo ?? false,
      );
    });
  }

  void _toggleOption(String key) {
    setState(() {
      switch (key) {
        case 'kazan':
          _model = _model.copyWith(hasKazan: !_model.hasKazan);
          break;
        case 'asansor':
          _model = _model.copyWith(hasAsansor: !_model.hasAsansor);
          _isAutoSelected = false; // User interacted with it
          break;
        case 'cati':
          _model = _model.copyWith(hasCati: !_model.hasCati);
          break;
        case 'jenerator':
          _model = _model.copyWith(hasJenerator: !_model.hasJenerator);
          break;
        case 'elektrik':
          _model = _model.copyWith(hasElektrik: !_model.hasElektrik);
          break;
        case 'trafo':
          _model = _model.copyWith(hasTrafo: !_model.hasTrafo);
          break;
        case 'cop':
          _model = _model.copyWith(hasCop: !_model.hasCop);
          break;
        case 'siginak':
          _model = _model.copyWith(hasSiginak: !_model.hasSiginak);
          break;
        case 'duvar':
          _model = _model.copyWith(hasDuvar: !_model.hasDuvar);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Özel Riskli Alanlar",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isConfirmed,
      onNext: () async {
        BinaStore.instance.bolum7 = _model;
        // saveToDisk is handled by AnalysisPageLayout
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum8Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "Binanızda aşağıdaki alanlardan hangileri mevcut?",
              style: AppStyles.questionTitle,
            ),
          ),

          _buildOption(
            Bolum7Content.kazan,
            _model.hasKazan,
            () => _toggleOption('kazan'),
          ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7Kazan,
            title: "Kazan Dairesi Teknik Detayı",
          ),
          const SizedBox(height: 8),

          _buildOption(
            Bolum7Content.asansor,
            _model.hasAsansor,
            () => _toggleOption('asansor'),
          ),
          if (_isAutoSelected && _model.hasAsansor)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                "ⓘ Asansör, Uygulama tarafından işaretlenmiştir. Binanızda asansör yoksa işareti kaldırabilirsiniz.",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.blueGrey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7Asansor,
            title: "Asansör Kuyusu ve Makine Dairesi",
          ),
          const SizedBox(height: 8),

          _buildOption(
            Bolum7Content.cati,
            _model.hasCati,
            () => _toggleOption('cati'),
          ),

          _buildOption(
            Bolum7Content.jenerator,
            _model.hasJenerator,
            () => _toggleOption('jenerator'),
          ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7Jenerator,
            title: "Jeneratör Odası Yerleşimi",
          ),
          const SizedBox(height: 8),

          _buildOption(
            Bolum7Content.elektrik,
            _model.hasElektrik,
            () => _toggleOption('elektrik'),
          ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7ElektrikOdasi,
            title: "Elektrik Tesisat Odası",
          ),
          const SizedBox(height: 8),

          _buildOption(
            Bolum7Content.trafo,
            _model.hasTrafo,
            () => _toggleOption('trafo'),
          ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7Trafo,
            title: "Trafo Odası ve Yağ Çukuru",
          ),
          const SizedBox(height: 8),

          _buildOption(
            Bolum7Content.cop,
            _model.hasCop,
            () => _toggleOption('cop'),
          ),
          _buildOption(
            Bolum7Content.siginak,
            _model.hasSiginak,
            () => _toggleOption('siginak'),
          ),

          _buildOption(
            Bolum7Content.duvar,
            _model.hasDuvar,
            () => _toggleOption('duvar'),
          ),
          TechnicalDrawingButton(
            assetPath: AppAssets.section7OrtakDuvar,
            title: "Bitişik Nizam Ortak Duvar Detayı",
          ),

          if (BinaStore.instance.bolum6?.buyukRestoran?.label ==
              Bolum6Content.buyukRestoranVar.label) ...[
            const SizedBox(height: 8),
            _buildOption(
              Bolum7Content.endustriyelMutfak,
              true, // Otomatik seçili gelsin çünkü Bölüm 6'da var dedi
              () {}, // Kilitli olsun, değiştiremesin
            ),
          ],

          const Padding(
            padding: EdgeInsets.only(top: 4, bottom: 8),
            child: Divider(color: Color(0xFFECEFF1)),
          ),

          // ONAY KUTUSU
          ConfirmationCheckbox(
            value: _isConfirmed,
            onChanged: (val) => setState(() => _isConfirmed = val ?? false),
            text:
                "Belirttiğim özel riskli hacimlerin binada mevcut olduğunu teyit ediyorum.",
          ),
        ],
      ),
    );
  }

  Widget _buildOption(dynamic choice, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SelectableCard(
        choice: choice,
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }
}
