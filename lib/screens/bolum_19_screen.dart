import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_19_model.dart';
import 'bolum_20_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../utils/app_assets.dart';
import '../../models/choice_result.dart';

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
      title: "Kaçış Yolu Engelleri ve Yönlendirme",
      subtitle: "",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () {
        BinaStore.instance.bolum19 = _model;
        BinaStore.instance.saveToDisk();
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
                  "Kaçış yollarında aşağıdakilerden hangisi var?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            ],
            _model.levha,
            imagePath: AppAssets.section19AcilYonlendirme,
            imageTitle: "Acil Durum Yönlendirme Levhaları",
          ),
          _buildSoru(
            "Yanıltıcı kapılar var mı? (Çıkış ulaşırken kafanızı karıştırabilecek türden kapılar)",
            'yaniltici',
            [Bolum19Content.yanilticiOptionA, Bolum19Content.yanilticiOptionB],
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
              "Bu kapıların üzerinde yazı var mı?",
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1A237E), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF1A237E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Color(0xFF4A148C),
            ),
          ),
          const SizedBox(height: 12),
          if (imagePath != null)
            TechnicalDrawingButton(
              assetPath: imagePath,
              title: imageTitle ?? "İlgili Görsel",
            ),
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
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_downward, color: Color(0xFFE65100)),
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
