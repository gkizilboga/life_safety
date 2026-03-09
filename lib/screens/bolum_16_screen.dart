import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_16_model.dart';
import 'bolum_17_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_assets.dart';
import '../../utils/input_validator.dart';

class Bolum16Screen extends StatefulWidget {
  const Bolum16Screen({super.key});

  @override
  State<Bolum16Screen> createState() => _Bolum16ScreenState();
}

class _Bolum16ScreenState extends State<Bolum16Screen> {
  Bolum16Model _model = Bolum16Model();
  bool _askBitisik = false;
  double _hBina = 0.0;

  @override
  void initState() {
    super.initState();
    _hBina = BinaStore.instance.bolum3?.hBina ?? 0.0;

    // Load existing data if available
    final savedModel = BinaStore.instance.bolum16;
    if (savedModel != null) {
      _model = savedModel;
    }

    final b8 = BinaStore.instance.bolum8;
    if (b8?.secim?.label.contains("Bitişik") == true ||
        b8?.secim?.label == "8-1-B") {
      _askBitisik = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSection16Selection(ChoiceResult choice) {
    setState(() {
      _model = _model.copyWith(mantolama: choice);
      if (choice.label == Bolum16Content.mantolamaOptionA.label) {
        if (_hBina > 28.50) {
          _model = _model.copyWith(
            bariyerYan: null,
            bariyerUst: null,
            bariyerZemin: null,
          );
        }
      } else {
        _model = _model.copyWith(
          bariyerYan: null,
          bariyerUst: null,
          bariyerZemin: null,
        );
      }
      if (choice.label != Bolum16Content.giydirmeOptionC.label) {
        _model = _model.copyWith(giydirmeBoslukYalitim: null);
      }
    });
  }

  bool _isReady() {
    if (_model.mantolama == null) return false;
    if (_model.mantolama?.label == Bolum16Content.mantolamaOptionA.label &&
        _hBina <= 28.50) {
      if (_model.bariyerYan == null ||
          _model.bariyerUst == null ||
          _model.bariyerZemin == null)
        return false;
    }
    if (_model.mantolama?.label == Bolum16Content.giydirmeOptionC.label &&
        _model.giydirmeBoslukYalitim == null)
      return false;
    if (_model.sagirYuzey == null) return false;
    if (_model.sagirYuzey?.label == Bolum16Content.sagirYuzeyOptionB.label &&
        _model.sagirYuzeySprinkler == null)
      return false;
    if (_askBitisik && _model.bitisikNizam == null) return false;
    if (_model.cepheUzunlugu == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Dış Cephe",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum16 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum17Screen()),
        );
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom built Question Card for strict layout control
            QuestionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Binanızdaki dış cephe kaplama veya ısı yalıtım sistemi nedir?",
                    style: AppStyles.questionTitle,
                  ),
                  const SizedBox(height: 12),

                  // Option A: Klasik Mantolama
                  SelectableCard(
                    choice: Bolum16Content.mantolamaOptionA,
                    isSelected:
                        _model.mantolama?.label ==
                        Bolum16Content.mantolamaOptionA.label,
                    onTap: () => _handleSection16Selection(
                      Bolum16Content.mantolamaOptionA,
                    ),
                    imageAssetPath: AppAssets.section16EpsMantolama,
                    imageTitle: "EPS / XPS Mantolama",
                  ),

                  // Option B: A1, A2 (Taşyünü)
                  SelectableCard(
                    choice: Bolum16Content.mantolamaOptionB,
                    isSelected:
                        _model.mantolama?.label ==
                        Bolum16Content.mantolamaOptionB.label,
                    onTap: () => _handleSection16Selection(
                      Bolum16Content.mantolamaOptionB,
                    ),
                    imageAssetPath: AppAssets.section16TasyunuMantolama,
                    imageTitle: "Taşyünü Mantolama",
                  ),

                  // Option C: Giydirme Cephe
                  SelectableCard(
                    choice: Bolum16Content.giydirmeOptionC,
                    isSelected:
                        _model.mantolama?.label ==
                        Bolum16Content.giydirmeOptionC.label,
                    onTap: () => _handleSection16Selection(
                      Bolum16Content.giydirmeOptionC,
                    ),
                    imageAssetPath: AppAssets.section16Giydirme,
                    imageTitle: "Giydirme Cephe Örneği",
                  ),

                  // Other Options
                  SelectableCard(
                    choice: Bolum16Content.mantolamaOptionD,
                    isSelected:
                        _model.mantolama?.label ==
                        Bolum16Content.mantolamaOptionD.label,
                    onTap: () => _handleSection16Selection(
                      Bolum16Content.mantolamaOptionD,
                    ),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.mantolamaOptionE,
                    isSelected:
                        _model.mantolama?.label ==
                        Bolum16Content.mantolamaOptionE.label,
                    onTap: () => _handleSection16Selection(
                      Bolum16Content.mantolamaOptionE,
                    ),
                  ),
                ],
              ),
            ),

            if (_model.mantolama?.label ==
                    Bolum16Content.mantolamaOptionA.label &&
                _hBina <= 28.50) ...[
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Seçtiğiniz \"Klasik Mantolama (EPS/XPS)\" yanıcı özellikte olduğu için, yönetmelik gereği aşağıdaki yangın bariyeri önlemlerinin alınıp alınmadığı kontrol edilmelidir.",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSubQuestion(
                null,
                "Pencerelerin yanlarında en az 15 cm eninde yanmaz bariyer var mı?",
                _model.bariyerYan,
                (v) => setState(() => _model = _model.copyWith(bariyerYan: v)),
              ),
              _buildSubQuestion(
                null,
                "Pencerelerin üstünde 30 cm eninde yanmaz bariyer var mı?",
                _model.bariyerUst,
                (v) => setState(() => _model = _model.copyWith(bariyerUst: v)),
              ),
              _buildSubQuestion(
                null,
                "Zemin seviyesinden 150 cm yüksekliğe kadar yanmaz malzemeyle kaplama var mı?",
                _model.bariyerZemin,
                (v) =>
                    setState(() => _model = _model.copyWith(bariyerZemin: v)),
              ),
            ],

            if (_model.mantolama?.label ==
                Bolum16Content.giydirmeOptionC.label) ...[
              CustomInfoNote(
                text: "Lütfen alttaki soruyu yanıtlayınız.",
                icon: Icons.arrow_downward,
              ),
              _buildSubQuestionRadio(
                "Cephe ile döşeme arasındaki boşluklar yalıtılmış mı?",
                _model.giydirmeBoslukYalitim,
                (v) => setState(
                  () => _model = _model.copyWith(giydirmeBoslukYalitim: v),
                ),
              ),
            ],

            _buildSoru(
              "Katlar arasında 100 cm yüksekliğinde yanmaz (sağır) yüzey var mı?",
              'sagir',
              [
                Bolum16Content.sagirYuzeyOptionA,
                Bolum16Content.sagirYuzeyOptionB,
                Bolum16Content.sagirYuzeyOptionC,
              ],
              _model.sagirYuzey,
              imagePath: AppAssets.section16Spandrel,
              imageTitle: "Spandrel Örneği",
            ),

            if (_model.sagirYuzey?.label ==
                Bolum16Content.sagirYuzeyOptionB.label) ...[
              CustomInfoNote(
                text: "Lütfen alttaki soruyu yanıtlayınız.",
                icon: Icons.arrow_downward,
              ),
              _buildSubQuestionRadio(
                "Cepheye doğru bakan özel sprinkler başlıkları var mı?",
                _model.sagirYuzeySprinkler,
                (v) => setState(
                  () => _model = _model.copyWith(sagirYuzeySprinkler: v),
                ),
              ),
            ],

            if (_askBitisik)
              _buildSoru(
                "Binanız bitişik nizamda bulunan yan bina ile karşılaştırıldığında yükseklik durumu nedir?",
                'bitisik',
                [
                  Bolum16Content.bitisikOptionA,
                  Bolum16Content.bitisikOptionB,
                  Bolum16Content.bitisikOptionC,
                  Bolum16Content.bitisikOptionD,
                ],
                _model.bitisikNizam,
                imagePath: AppAssets.section16Sicrama,
                imageTitle: "Yan Binadan Sıçrama Detayı",
              ),

            const SizedBox(height: 16),
            QuestionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Binanızın en uzun cephesinin uzunluğu kaç metredir?",
                    style: AppStyles.questionTitle,
                  ),
                  const SizedBox(height: 12),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguOlumlu,
                    isSelected:
                        _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguOlumlu.label,
                    onTap: () => setState(
                      () => _model = _model.copyWith(
                        cepheUzunlugu: Bolum16Content.cepheUzunluguOlumlu,
                      ),
                    ),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguKritik,
                    isSelected:
                        _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguKritik.label,
                    onTap: () => setState(
                      () => _model = _model.copyWith(
                        cepheUzunlugu: Bolum16Content.cepheUzunluguKritik,
                      ),
                    ),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguBilinmiyor,
                    isSelected:
                        _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguBilinmiyor.label,
                    onTap: () => setState(
                      () => _model = _model.copyWith(
                        cepheUzunlugu: Bolum16Content.cepheUzunluguBilinmiyor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoru(
    String title,
    String k,
    List<ChoiceResult> o,
    ChoiceResult? s, {
    String? imagePath,
    String? imageTitle,
  }) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null)
            QuestionHeaderWithImage(
              questionText: title,
              imageAssetPath: imagePath,
              imageTitle: imageTitle ?? "Görseli İncele",
            )
          else
            Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 12),
          ...o.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: s?.label == opt.label,
              onTap: () {
                setState(() {
                  if (k == 'sagir') {
                    _model = _model.copyWith(sagirYuzey: opt);
                    if (opt.label != Bolum16Content.sagirYuzeyOptionB.label) {
                      _model = _model.copyWith(sagirYuzeySprinkler: null);
                    }
                  }
                  if (k == 'bitisik') {
                    _model = _model.copyWith(bitisikNizam: opt);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubQuestion(
    Key? key,
    String title,
    int? groupValue,
    Function(int?) onChanged,
  ) {
    return Container(
      key: key,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle.copyWith(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Radio<int>(
                value: 1,
                groupValue: groupValue,
                activeColor: const Color(0xFF1A237E),
                onChanged: onChanged,
              ),
              const Text("Evet", style: TextStyle(fontSize: 12)),
              Radio<int>(
                value: 0,
                groupValue: groupValue,
                activeColor: const Color(0xFF1A237E),
                onChanged: onChanged,
              ),
              const Text("Hayır", style: TextStyle(fontSize: 12)),
              Radio<int>(
                value: 2,
                groupValue: groupValue,
                activeColor: const Color(0xFF1A237E),
                onChanged: onChanged,
              ),
              const Text("Bilmiyorum", style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubQuestionRadio(
    String title,
    bool? groupValue,
    Function(bool?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: groupValue,
                activeColor: const Color(0xFF1A237E),
                onChanged: onChanged,
              ),
              const Text("Evet", style: TextStyle(fontSize: 13)),
              const SizedBox(width: 15),
              Radio<bool>(
                value: false,
                groupValue: groupValue,
                activeColor: const Color(0xFF1A237E),
                onChanged: onChanged,
              ),
              const Text("Hayır", style: TextStyle(fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
