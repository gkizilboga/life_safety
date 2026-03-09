import 'package:flutter/material.dart';
import 'package:life_safety/screens/module_transition.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_10_model.dart';
import 'bolum_11_screen.dart';
import 'module_transition_screen.dart';
import '../../logic/report_engine.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum10Screen extends StatefulWidget {
  const Bolum10Screen({super.key});

  @override
  State<Bolum10Screen> createState() => _Bolum10ScreenState();
}

class _Bolum10ScreenState extends State<Bolum10Screen> {
  Bolum10Model _model = Bolum10Model();
  bool _isSummaryAccepted = false;

  @override
  void initState() {
    super.initState();
    final b3 = BinaStore.instance.bolum3;
    int bCount = int.tryParse(b3?.bodrumKatSayisi?.toString() ?? "0") ?? 0;
    int nCount = int.tryParse(b3?.normalKatSayisi?.toString() ?? "0") ?? 0;

    final existing = BinaStore.instance.bolum10;
    if (existing != null) {
      _model = existing;
      // Ensure local lists match Section 3 counts if they changed, otherwise use existing
      if (_model.bodrumlar.length != bCount) {
        _model = _model.copyWith(bodrumlar: List.filled(bCount, null));
      }
      if (_model.normaller.length != nCount) {
        _model = _model.copyWith(normaller: List.filled(nCount, null));
      }
      _isSummaryAccepted = true;
    } else {
      _model = Bolum10Model(
        bodrumlar: List.filled(bCount, null),
        normaller: List.filled(nCount, null),
        bodrumlarAyni: true,
        normallerAyni: true,
      );
    }
  }

  void _handleSelection(String type, ChoiceResult choice, {int? index}) {
    setState(() {
      _isSummaryAccepted = false;
      if (type == 'zemin') {
        _model = _model.copyWith(zemin: choice);
      } else if (type == 'bodrum') {
        List<ChoiceResult?> newList = List.from(_model.bodrumlar);
        if (_model.bodrumlarAyni) {
          newList = List.filled(newList.length, choice);
          _model = _model.copyWith(bodrumlar: newList);
        } else {
          if (index != null) newList[index] = choice;
          _model = _model.copyWith(bodrumlar: newList);
        }
      } else if (type == 'normal') {
        List<ChoiceResult?> newList = List.from(_model.normaller);
        if (_model.normallerAyni) {
          newList = List.filled(newList.length, choice);
          _model = _model.copyWith(normaller: newList);
        } else {
          if (index != null) newList[index] = choice;
          _model = _model.copyWith(normaller: newList);
        }
      }
    });
  }

  bool _checkIfComplete() {
    if (_model.zemin == null) return false;
    if (_model.bodrumlar.any((e) => e == null)) return false;
    if (_model.normaller.any((e) => e == null)) return false;
    return true;
  }

  bool _hasKonutSelection() {
    // Check Zemin
    if (_model.zemin?.label == Bolum10Content.konut.label) return true;

    // Check Bodrumlar
    if (_model.bodrumlar.any((e) => e?.label == Bolum10Content.konut.label)) {
      return true;
    }

    // Check Normaller
    if (_model.normaller.any((e) => e?.label == Bolum10Content.konut.label)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kat Kullanım Amacı",
      screenType: widget.runtimeType,
      isNextEnabled: _checkIfComplete() && _isSummaryAccepted,
      onNext: () {
        if (!_hasKonutSelection()) {
          showCustomDialog(
            context: context,
            title: "Eksik Seçim",
            content:
                "Bu uygulama Konut binaları için tasarlanmıştır. Katlardan en az biri için 'Konut' (Daire) seçeneğini işaretlemelisiniz.",
            confirmText: "Tamam",
            icon: Icons.error_outline_rounded,
            iconColor: Colors.red,
          );
          return;
        }

        BinaStore.instance.bolum10 = _model;
        BinaStore.instance.saveToDisk();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleTransitionScreen(
              module: ReportModule.binaBilgileri,
              onContinue: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bolum11Screen(),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTicariGuidance(),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionHeaderWithImage(
              questionText: "Zemin Katın Kullanım Amacı",
              imageAssetPath: 'assets/images/sections/farkli_katlar_1.webp',
              imageTitle: "Kat Kullanım Örnekleri",
            ),
          ),
          _buildChoiceGrid('zemin', null, _model.zemin),

          if (_model.bodrumlar.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSectionTitle("Bodrum Katların Kullanım Amacı"),
            _buildToggleRow(
              "Tüm bodrumlar aynı fonksiyona sahip",
              _model.bodrumlarAyni,
              (val) {
                setState(() => _model = _model.copyWith(bodrumlarAyni: val));
              },
            ),
            if (_model.bodrumlarAyni)
              _buildChoiceGrid('bodrum', 0, _model.bodrumlar[0])
            else
              ...List.generate(
                _model.bodrumlar.length,
                (i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 8,
                        left: 4,
                      ),
                      child: Text(
                        "${i + 1}. Bodrum Katların Kullanım Amacı",
                        style: AppStyles.questionTitle.copyWith(fontSize: 14),
                      ),
                    ),
                    _buildChoiceGrid('bodrum', i, _model.bodrumlar[i]),
                  ],
                ),
              ),
          ],

          if (_model.normaller.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildSectionTitle("Normal Katların Kullanım Amacı"),
            _buildToggleRow(
              "Tüm normal katlar aynı fonksiyona sahip",
              _model.normallerAyni,
              (val) {
                setState(() => _model = _model.copyWith(normallerAyni: val));
              },
            ),
            if (_model.normallerAyni)
              _buildChoiceGrid('normal', 0, _model.normaller[0])
            else
              ...List.generate(
                _model.normaller.length,
                (i) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 8,
                        left: 4,
                      ),
                      child: Text(
                        "${i + 1}. Normal Katın Kullanım Amacı",
                        style: AppStyles.questionTitle.copyWith(fontSize: 14),
                      ),
                    ),
                    _buildChoiceGrid('normal', i, _model.normaller[i]),
                  ],
                ),
              ),
          ],

          if (_checkIfComplete())
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _buildSummaryCard(),
            ),
        ],
      ),
    );
  }

  Widget _buildTicariGuidance() {
    final bool hasTicari = BinaStore.instance.bolum6?.hasTicari ?? false;
    if (hasTicari) return const SizedBox.shrink();

    return CustomInfoNote(
      icon: Icons.storefront_outlined,
      text:
          "Binanızda ticari alanlar (dükkan, işyeri, vb.) mevcutsa, lütfen Bölüm-6'ya dönerek 'Ticari Alan' seçeneğini işaretlemeniz gereklidir.",
      margin: const EdgeInsets.only(bottom: 24),
    );
  }

  Widget _buildChoiceGrid(String type, int? index, ChoiceResult? selected) {
    final bool hasTicari = BinaStore.instance.bolum6?.hasTicari ?? false;
    final choices =
        [
          Bolum10Content.konut,
          Bolum10Content.azYogunTicari,
          Bolum10Content.ortaYogunTicari,
          Bolum10Content.yuksekYogunTicari,
          Bolum10Content.teknikDepo,
        ].where((c) {
          if (hasTicari) return true;
          // Ticari olmayan durumda 10-B, 10-C ve 10-D şıklarını gizle
          return !['10-B', '10-C', '10-D'].contains(c.label);
        }).toList();

    return Column(
      children: choices
          .map(
            (c) => SelectableCard(
              choice: c,
              isSelected: selected?.label == c.label,
              onTap: () => _handleSelection(type, c, index: index),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: AppStyles.questionTitle),
    );
  }

  Widget _buildToggleRow(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF1A237E),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ConfirmationCheckbox(
            value: _isSummaryAccepted,
            onChanged: (val) =>
                setState(() => _isSummaryAccepted = val ?? false),
            text:
                "Katların kullanım amaçlarını doğru işaretlediğimi onaylıyorum.",
          ),
        ],
      ),
    );
  }
}
