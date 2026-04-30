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
    } else {
      // Çoğu binada yanıltıcı kapı bulunmadığı için varsayılan olarak "Yok" seçiyoruz.
      _model = _model.copyWith(yanilticiKapi: Bolum19Content.yanilticiOptionA);
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
    final bool engellerReady = _model.engeller.isNotEmpty;
    final bool levhaReady = _model.levha != null;
    final bool yanilticiReady = _model.yanilticiKapi != null;

    if (!engellerReady || !levhaReady || !yanilticiReady) return false;

    if (_model.yanilticiKapi?.label == Bolum19Content.yanilticiOptionB.label &&
        _model.yanilticiEtiket == null)
      return false;
    return true;
  }

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Acil Durum Yönlendirme",
      screenType: widget.runtimeType,
      isNextEnabled: _isReady(),
      onNext: () async {
        if (_isProcessing) return;
        setState(() => _isProcessing = true);

        try {
          BinaStore.instance.bolum19 = _model;
          final navigator = Navigator.of(context);
          await BinaStore.instance.saveToDisk();

          if (!mounted) return;
          navigator.push(
            MaterialPageRoute(builder: (context) => const Bolum20Screen()),
          );
        } catch (e) {
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Hata: Bölüm 20'ye Geçilemedi"),
              content: Text(
                "Geçiş sırasında bir hata oluştu. Lütfen bu mesajı geliştiriciye bildirin:\n\n$e",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Tamam"),
                ),
              ],
            ),
          );
        } finally {
          if (mounted) setState(() => _isProcessing = false);
        }
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
                const MultiSelectHint(),
                const SizedBox(height: 12),
                ...[
                  Bolum19Content.engelOptionA,
                  Bolum19Content.engelOptionB,
                  Bolum19Content.engelOptionC,
                  Bolum19Content.engelOptionD,
                  Bolum19Content.engelOptionE,
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
            imageTitle: "Yönlendirme levhası",
          ),
          // Yanıltıcı kapı sorusu — Bölüm 21 ile aynı yapı:
          // soru metni + kamera ikonu + DefinitionButton yan yana
          _buildSoru(
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Yanıltıcı kapılar var mı? (Çıkışa ulaşırken kafanızı karıştırabilecek türden kapılar)",
                    style: AppStyles.questionTitle,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => ImageModalHelper.show(
                    context,
                    assetPath: AppAssets.section19YanilticiKapi,
                    title: "Yanıltıcı kapı örneği",
                  ),
                  child: Tooltip(
                    message: 'Görseli incele',
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43A047).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.photo_camera,
                        color: Color(0xFF2E7D32),
                        size: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DefinitionButton(
                  term: "Yanıltıcı Kapı Nedir?",
                  definition:
                      "Kaçış yolu üzerinde bulunan, kullanıcıyı yanlışlıkla çıkmaz bir alana (depo, elektrik odası vb.) yönlendirebilecek ve üzerinde 'ÇIKIŞ DEĞİLDİR' veya mahalin adı (örneğin 'KAZAN DAİRESİ') yazılı olmayan kapılardır.",
                ),
              ],
            ),
            'yaniltici',
            [
              Bolum19Content.yanilticiOptionA,
              Bolum19Content.yanilticiOptionB,
              Bolum19Content.yanilticiOptionC,
            ],
            _model.yanilticiKapi,
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
      type: InfoNoteType.info,
      text: text,
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildSoru(
    dynamic title,
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
          if (title is String) ...[
            if (imagePath != null)
              QuestionHeaderWithImage(
                questionText: title,
                imageAssetPath: imagePath,
                imageTitle: imageTitle ?? "Acil durum yönlendirme detayı",
              )
            else ...[
              Text(title, style: AppStyles.questionTitle),
              const SizedBox(height: 12),
            ],
          ] else if (title is Widget) ...[
            title,
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
    return CustomInfoNote(
      type: InfoNoteType.info,
      text: text,
      icon: Icons.arrow_downward,
    );
  }
}
