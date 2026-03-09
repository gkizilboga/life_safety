import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_19_model.dart';
import 'bolum_20_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../utils/app_assets.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum19Screen extends StatefulWidget {
  const Bolum19Screen({super.key});

  @override
  State<Bolum19Screen> createState() => _Bolum19ScreenState();
}

class _Bolum19ScreenState extends State<Bolum19Screen> {
  Bolum19Model _model = Bolum19Model();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum19 != null) {
      _model = BinaStore.instance.bolum19!;
    }
  }

  void _handleEngelSelection(ChoiceResult choice) {
    setState(() {
      List<ChoiceResult> current = List.from(_model.engeller);
      if (choice.label == Bolum19Content.engelOptionA.label)
        current = [choice];
      else {
        current.removeWhere(
          (e) => e.label == Bolum19Content.engelOptionA.label,
        );
        if (current.any((e) => e.label == choice.label))
          current.removeWhere((e) => e.label == choice.label);
        else
          current.add(choice);
      }
      _model = _model.copyWith(engeller: current);
    });
  }

  void _handleSelection(String type, ChoiceResult choice) {
    setState(() {
      if (type == 'levha') {
        _model = _model.copyWith(levha: choice);
      }
      if (type == 'yaniltici') {
        _model = _model.copyWith(yanilticiKapi: choice);
        if (choice.label != Bolum19Content.yanilticiOptionB.label)
          _model = _model.copyWith(yanilticiEtiket: null);
      }
      if (type == 'etiket') _model = _model.copyWith(yanilticiEtiket: choice);
    });
  }

  bool _isReady() {
    if (_model.engeller.isEmpty ||
        _model.levha == null ||
        _model.yanilticiKapi == null)
      return false;
    if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label &&
        _model.yanilticiEtiket == null)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Acil Durum Yönlendirme",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum19 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum20Screen()),
        );
      },
      child: Column(
        children: [
          _buildTopInfoNote(
            "Not: Yönetmelik gereği tek çıkışlı veya tek merdivenli binalarda acil durum yönlendirme levhası zorunluluğu aranmayabilir. Analizin sonunda bu durum otomatik değerlendirilecektir.",
          ),
          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kaçış yolları nasıl?",
                  style: AppStyles.questionTitle,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Birden fazla seçenek işaretleyebilirsiniz.",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),
                ...[
                  Bolum19Content.engelOptionA,
                  Bolum19Content.engelOptionB,
                  Bolum19Content.engelOptionC,
                  Bolum19Content.engelOptionD,
                ].map(
                  (opt) => SelectableCard(
                    choice: opt,
                    isSelected: _model.engeller.any(
                      (e) => e.label == opt.label,
                    ),
                    onTap: () => _handleEngelSelection(opt),
                  ),
                ),
              ],
            ),
          ),
          _buildSoru(
            "Yönlendirme levhaları asılı mı?",
            'levha',
            [
              Bolum19Content.levhaOptionA,
              Bolum19Content.levhaOptionB,
              Bolum19Content.levhaOptionC,
              Bolum19Content.levhaOptionD,
            ],
            _model.levha,
            imagePath: AppAssets.section19AcilYonlendirme,
            imageTitle: "Acil Durum Yönlendirme Levhaları",
          ),
          _buildSoru(
            "Yanıltıcı kapılar var mı? (Çıkışa ulaşırken kafanızı karıştırabilecek türden kapılar)",
            'yaniltici',
            [
              Bolum19Content.yanilticiOptionA,
              Bolum19Content.yanilticiOptionB,
              Bolum19Content.yanilticiOptionC,
            ],
            _model.yanilticiKapi,
            imagePath: AppAssets.section19YanilticiKapi,
            imageTitle: "Yanıltıcı Kapı Örneği",
          ),

          if (_model.yanilticiKapi?.label ==
              Bolum19Content.yanilticiOptionB.label) ...[
            _buildInfoNote(
              "Yanıltıcı kapılar için etiketleme sorgulanmaktadır.",
            ),
            _buildSoru(
              "Yanıltıcı kapıların üzerinde mahalin adı yazıyor mu? (Depo, elektrik odası vb.)",
              'etiket',
              [
                Bolum19Content.etiketOptionA,
                Bolum19Content.etiketOptionB,
                Bolum19Content.etiketOptionC,
              ],
              _model.yanilticiEtiket,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopInfoNote(String text) {
    return CustomInfoNote(
      text: text,
      icon: Icons.info_outline,
      backgroundColor: Colors.blue.shade50,
      borderColor: Colors.blue.shade200,
      iconColor: const Color(0xFF1A237E),
      textColor: const Color(0xFF1A237E),
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildSoru(
    String title,
    String key,
    List<ChoiceResult> options,
    ChoiceResult? selected, {
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
          else ...[
            Text(title, style: AppStyles.questionTitle),
            const SizedBox(height: 12),
          ],
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
    return CustomInfoNote(text: text, icon: Icons.arrow_downward);
  }
}
