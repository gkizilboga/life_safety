import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/bina_store.dart';
import '../models/choice_result.dart';
import '../providers/bolum_20_provider.dart';
import '../utils/app_assets.dart';
import '../utils/app_content.dart';
import '../utils/app_theme.dart';
import '../utils/input_validator.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import 'bolum_21_screen.dart';
import 'module_transition.dart';
import '../logic/report_engine.dart'; // For ReportModule

class Bolum20Screen extends StatefulWidget {
  const Bolum20Screen({super.key});

  @override
  State<Bolum20Screen> createState() => _Bolum20ScreenState();
}

class _Bolum20ScreenState extends State<Bolum20Screen> {
  // CRITICAL: Provider must be created once in initState, NOT inside build().
  // Creating it inside build() causes a new provider (with full initialization)
  // to be created on every rebuild, causing an infinite rebuild loop.
  late final Bolum20Provider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Bolum20Provider();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: const _Bolum20ScreenContent(),
    );
  }
}

class _Bolum20ScreenContent extends StatefulWidget {
  const _Bolum20ScreenContent();

  @override
  State<_Bolum20ScreenContent> createState() => _Bolum20ScreenContentState();
}

class _Bolum20ScreenContentState extends State<_Bolum20ScreenContent> {
  @override
  Widget build(BuildContext context) {
    // Read the provider once, use Selectors or context.select for reactive parts
    final provider = context.read<Bolum20Provider>();

    // These values determine high-level UI structure and reactivity
    final isTekKatli = context.select((Bolum20Provider p) => p.isTekKatli);
    final isLimitValid = context.select((Bolum20Provider p) => p.isLimitValid);
    final hasBodrum = context.select((Bolum20Provider p) => p.hasBodrum);
    final isBodrumIndependent = context.select(
      (Bolum20Provider p) => p.isBodrumIndependent,
    );
    final showBasinclandirma = context.select(
      (Bolum20Provider p) => p.showBasinclandirma,
    );

    bool _isProcessing = false;

    return AnalysisPageLayout(
      title: "Kaçış Merdivenleri",
      screenType: Bolum20Screen,
      isNextEnabled: isLimitValid,
      onNext: () async {
        if (_isProcessing) return;
        _isProcessing = true;

        try {
          if (provider.validateAndSave(context)) {
            final navigator = Navigator.of(context);

            if (provider.isBodrumIndependent) {
              bool confirmed =
                  await showCustomDialog<bool>(
                    context: context,
                    title: "Dikkat:",
                    content:
                        "Bodrum kat merdivenlerinin, üst kat merdivenlerinden FARKLI bir konumda olduğunu belirttiniz.\n\nBu durum, kaçış yollarının sürekliliği açısından kritik bir bilgidir.\n\nOnaylıyor musunuz?",
                    confirmText: "Evet",
                    cancelText: "Hayır",
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.orange,
                    barrierDismissible: false,
                  ) ??
                  false;

              if (!confirmed) {
                _isProcessing = false;
                return;
              }
            }

            if (!mounted) return;
            navigator.push(
              MaterialPageRoute(
                builder: (context) => ModuleTransitionScreen(
                  module: ReportModule.modul2,
                  onContinue: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Bolum21Screen(),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            _isProcessing = false;
            if (isLimitValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Lütfen gerekli alanları doğru şekilde doldurunuz.",
                  ),
                ),
              );
            }
          }
        } catch (e) {
          _isProcessing = false;
          debugPrint("Bolum 20 Navigation Error: $e");
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTekKatli) ...[
              Selector<Bolum20Provider, ChoiceResult?>(
                selector: (_, p) => p.model.tekKatCikis,
                builder: (context, val, _) => StairQuestion(
                  key: const ValueKey('tekKatCikis'),
                  provider: provider,
                  title:
                      "Binadan dışarıya (sokağa veya caddeye) çıkışınız nasıl?",
                  keyParam: 'tekKatCikis',
                  options: [Bolum20Content.tekKatOptionA],
                  selected: val,
                ),
              ),
              Selector<Bolum20Provider, ChoiceResult?>(
                selector: (_, p) => p.model.tekKatRampa,
                builder: (context, val, _) => StairQuestion(
                  key: const ValueKey('tekKatRampa'),
                  provider: provider,
                  title:
                      "Binadan dışarıya çıkarken rampa kullanmak zorunda kalıyor musunuz?",
                  keyParam: 'tekKatRampa',
                  options: [
                    Bolum20Content.rampaOptionB,
                    Bolum20Content.rampaOptionC,
                  ],
                  selected: val,
                ),
              ),
            ] else ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 16),
                child: Text(
                  "Binanızda aşağıdaki merdiven türlerinden kaçar tane var?",
                  style: AppStyles.questionTitle,
                ),
              ),

              StairInputGroupCard(
                key: const ValueKey('main_stairs_card'),
                provider: provider,
              ),

              // Stair Classification Summary
              const SizedBox(height: 24),
              _StairClassificationSummary(
                key: const ValueKey('main_summary'),
                provider: provider,
              ),

              // Total Direct Exits Question (Upper Floors)
              const SizedBox(height: 12),
              _TotalDirectInputWidget(
                key: const ValueKey('main_direct_input'),
                provider: provider,
                isBasement: false,
              ),

              // LOBI MESAFE SORUSU (Madde 41)
              Selector<Bolum20Provider, bool>(
                selector: (_, p) => p.shouldShowLobbyDistanceQuestion,
                builder: (context, show, _) => show
                    ? Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: _LobbyDistanceInputWidget(
                          key: const ValueKey('main_lobby_input'),
                          provider: provider,
                          isBasement: false,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],

            if (hasBodrum)
              Selector<Bolum20Provider, ChoiceResult?>(
                selector: (_, p) => p.model.bodrumMerdivenDevami,
                builder: (context, val, _) => StairQuestion(
                  key: const ValueKey('bodrum_devam_q'),
                  provider: provider,
                  title:
                      "Bodrum kata inen merdiveniniz, üst katlara çıkan merdivenin devamı mı?",
                  keyParam: 'bodrum',
                  options: [
                    Bolum20Content.bodrumOptionA,
                    Bolum20Content.bodrumOptionB,
                  ],
                  selected: val,
                ),
              ),

            // Independent Basement Stairs Section
            if (isBodrumIndependent) ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 16, top: 20),
                child: Text(
                  "Bodrum Katlar İçin Özel Merdiven Bilgileri",
                  style: AppStyles.questionTitle,
                ),
              ),
              CustomInfoNote(
                type: InfoNoteType.info,
                text:
                    "Bağımsız olduğunu belirttiğiniz bodrum kat merdivenlerinin türlerini ve sayılarını aşağıya giriniz.",
                icon: Icons.info_outline,
              ),
              BasementStairInputGroupCard(
                key: const ValueKey('bod_stairs_card'),
                provider: provider,
              ),

              // Total Direct Exits Question (Basement)
              const SizedBox(height: 16),
              _TotalDirectInputWidget(
                key: const ValueKey('bod_direct_input'),
                provider: provider,
                isBasement: true,
              ),

              // Basement Lobby Distance
              Selector<Bolum20Provider, bool>(
                selector: (_, p) => p.shouldShowBasementLobbyDistanceQuestion,
                builder: (context, show, _) => show
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _LobbyDistanceInputWidget(
                          key: const ValueKey('bod_lobby_input'),
                          provider: provider,
                          isBasement: true,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],

            if (showBasinclandirma)
              Selector<Bolum20Provider, ChoiceResult?>(
                selector: (_, p) => p.model.basinclandirma,
                builder: (context, val, _) => StairQuestion(
                  key: const ValueKey('basinclandirma_q'),
                  provider: provider,
                  title: "Merdivenlerde basınçlandırma sistemi var mı?",
                  definition: AppDefinitions
                      .basinclandirma, // In AppDefinitions (inside app_content)
                  term: "Basınçlandırma Sistemi",
                  keyParam: 'basinclandirma',
                  options: [
                    Bolum20Content.basYghOptionA,
                    Bolum20Content.basYghOptionB,
                    Bolum20Content.basYghOptionC,
                  ],
                  selected: val,
                ),
              ),

            if (!isTekKatli)
              Selector<Bolum20Provider, ChoiceResult?>(
                selector: (_, p) => p.model.havalandirma,
                builder: (context, val, _) => StairQuestion(
                  key: const ValueKey('havalandirma_q'),
                  provider: provider,
                  title:
                      "Basınçlandırma olmayan merdivenlerde doğal havalandırma var mı?",
                  definition: AppDefinitions
                      .havalandirma, // In AppDefinitions (inside app_content)
                  term: "Havalandırma (Madde 45)",
                  keyParam: 'havalandirma',
                  options: [
                    Bolum20Content.havalandirmaOptionA,
                    Bolum20Content.havalandirmaOptionB,
                    Bolum20Content.havalandirmaOptionC,
                    Bolum20Content.havalandirmaOptionD,
                  ],
                  selected: val,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Specialized Widgets for Optimized Rebuilds ---

class _TotalDirectInputWidget extends StatelessWidget {
  final Bolum20Provider provider;
  final bool isBasement;

  const _TotalDirectInputWidget({
    super.key,
    required this.provider,
    required this.isBasement,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<Bolum20Provider, int>(
      selector: (_, p) =>
          isBasement ? p.totalBasementStairs : p.totalMainStairs,
      builder: (context, total, _) {
        if (total == 0) return const SizedBox.shrink();

        final ctrl = isBasement
            ? provider.bodToplamDirectCtrl
            : provider.toplamDirectCtrl;
        final title = isBasement
            ? "Bodrum Kat: Dışarıya Açılan Merdivenler"
            : "Dışarıya Açılan Merdivenler";
        String desc =
            "Bu $total adet merdivenden kaç tanesi doğrudan dışarı (bina dışına) açılmaktadır?";

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isBasement ? const Color(0xFFFFF8E1) : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isBasement ? const Color(0xFFFFCC80) : const Color(0xFFBBDEFB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.questionTitle),
              const SizedBox(height: 8),
              Text(desc, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              SizedBox(
                width: 120,
                child: TextField(
                  controller: ctrl,
                  onChanged: (val) => provider.updateController(
                    isBasement ? 'bodToplamDirect' : 'toplamDirect',
                    val,
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [InputValidator.positiveInteger],
                  decoration: InputDecoration(
                    hintText: "0",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Selector<Bolum20Provider, String?>(
                selector: (_, p) =>
                    isBasement ? p.bodToplamDirectErr : p.toplamDirectErr,
                builder: (context, err, _) {
                  if (err == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8, left: 2),
                    child: Text(
                      err,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LobbyDistanceInputWidget extends StatelessWidget {
  final Bolum20Provider provider;
  final bool isBasement;

  const _LobbyDistanceInputWidget({
    super.key,
    required this.provider,
    required this.isBasement,
  });

  @override
  Widget build(BuildContext context) {
    // Get sprinkler status from Bolum9
    final hasSprinkler = BinaStore.instance.bolum9?.secim?.label == "9-1-A";
    final limit = hasSprinkler ? 15 : 10;

    final title = isBasement
        ? "Bodrum Kat: Lobi/Koridor Tahliye Mesafesi"
        : "Lobi/Koridor Tahliye Mesafesi";
    final question =
        "Dışarıya açılmayan merdivenlerin bina içi tahliye mesafesi $limit metrenin altında mı?";

    return Selector<Bolum20Provider, ChoiceResult?>(
      selector: (_, p) =>
          isBasement ? p.bodLobiMesafeDurumu : p.lobiMesafeDurumu,
      builder: (context, currentSelection, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isBasement ? const Color(0xFFFFF8E1) : const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isBasement ? const Color(0xFFFFCC80) : const Color(0xFFBBDEFB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.questionTitle),
              const SizedBox(height: 8),
              SubQuestionTitle(question),
              SelectableCard(
                choice: Bolum20Content.madde41MesafeAltinda.copyWith(
                  uiTitle: "$limit metre veya altında",
                ),
                isSelected:
                    currentSelection?.label ==
                    Bolum20Content.madde41MesafeAltinda.label,
                onTap: () {
                  provider.handleSelection(
                    isBasement ? 'bodLobiMesafeDurumu' : 'lobiMesafeDurumu',
                    Bolum20Content.madde41MesafeAltinda,
                  );
                },
              ),
              SelectableCard(
                choice: Bolum20Content.madde41MesafeUstunde.copyWith(
                  uiTitle: "$limit metrenin üzerinde",
                ),
                isSelected:
                    currentSelection?.label ==
                    Bolum20Content.madde41MesafeUstunde.label,
                onTap: () {
                  provider.handleSelection(
                    isBasement ? 'bodLobiMesafeDurumu' : 'lobiMesafeDurumu',
                    Bolum20Content.madde41MesafeUstunde,
                  );
                },
              ),
              SelectableCard(
                choice: Bolum20Content.madde41MesafeBilmiyorum,
                isSelected:
                    currentSelection?.label ==
                    Bolum20Content.madde41MesafeBilmiyorum.label,
                onTap: () {
                  provider.handleSelection(
                    isBasement ? 'bodLobiMesafeDurumu' : 'lobiMesafeDurumu',
                    Bolum20Content.madde41MesafeBilmiyorum,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class StairInputGroupCard extends StatelessWidget {
  final Bolum20Provider provider;
  const StairInputGroupCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      child: Column(
        children: [
          _StairInputRow(
            key: const ValueKey('n_normal'),
            label: Bolum20Content.cokKatOption1.uiTitle,
            ctrl: provider.normalCtrl,
            error: context.select((Bolum20Provider p) => p.normalErr),
            assetPath: AppAssets.section20Normal,
            onChange: (val) => provider.updateController('normal', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_ic_kapali'),
            label: Bolum20Content.cokKatOption2.uiTitle,
            ctrl: provider.icKapaliCtrl,
            error: context.select((Bolum20Provider p) => p.icKapaliErr),
            assetPath: AppAssets.section20IcKapali,
            onChange: (val) => provider.updateController('icKapali', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_dis_kapali'),
            label: Bolum20Content.cokKatOption3.uiTitle,
            ctrl: provider.disKapaliCtrl,
            error: context.select((Bolum20Provider p) => p.disKapaliErr),
            assetPath: AppAssets.section20DisKapali,
            onChange: (val) => provider.updateController('disKapali', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_dis_acik'),
            label: Bolum20Content.cokKatOption4.uiTitle,
            ctrl: provider.disAcikCtrl,
            error: context.select((Bolum20Provider p) => p.disAcikErr),
            assetPaths: const [
              AppAssets.section20DisAcik2,
              AppAssets.section20DisAcik3,
            ],
            onChange: (val) => provider.updateController('disAcik', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_doner'),
            label: Bolum20Content.cokKatOption5.uiTitle,
            ctrl: provider.donerCtrl,
            error: context.select((Bolum20Provider p) => p.donerErr),
            assetPath: AppAssets.section20Dairesel,
            onChange: (val) => provider.updateController('doner', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_sahanliksiz'),
            label: Bolum20Content.cokKatOption6.uiTitle,
            ctrl: provider.sahanliksizCtrl,
            error: context.select((Bolum20Provider p) => p.sahanliksizErr),
            onChange: (val) => provider.updateController('sahanliksiz', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('n_dengelenmis'),
            label: Bolum20Content.cokKatOption7.uiTitle,
            ctrl: provider.dengelenmisCtrl,
            error: context.select((Bolum20Provider p) => p.dengelenmisErr),
            assetPath: AppAssets.section20Dengelenmis,
            onChange: (val) => provider.updateController('dengelenmis', val),
          ),
        ],
      ),
    );
  }
}

class BasementStairInputGroupCard extends StatelessWidget {
  final Bolum20Provider provider;
  const BasementStairInputGroupCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      child: Column(
        children: [
          _StairInputRow(
            key: const ValueKey('b_normal'),
            label: "Bodrum: ${Bolum20Content.cokKatOption1.uiTitle}",
            ctrl: provider.bodNormalCtrl,
            error: context.select((Bolum20Provider p) => p.bodNormalErr),
            onChange: (val) => provider.updateController('bodNormal', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_ic_kapali'),
            label: "Bodrum: ${Bolum20Content.cokKatOption2.uiTitle}",
            ctrl: provider.bodIcKapaliCtrl,
            error: context.select((Bolum20Provider p) => p.bodIcKapaliErr),
            onChange: (val) => provider.updateController('bodIcKapali', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_dis_kapali'),
            label: "Bodrum: ${Bolum20Content.cokKatOption3.uiTitle}",
            ctrl: provider.bodDisKapaliCtrl,
            error: context.select((Bolum20Provider p) => p.bodDisKapaliErr),
            onChange: (val) => provider.updateController('bodDisKapali', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_dis_acik'),
            label: "Bodrum: ${Bolum20Content.cokKatOption4.uiTitle}",
            ctrl: provider.bodDisAcikCtrl,
            error: context.select((Bolum20Provider p) => p.bodDisAcikErr),
            onChange: (val) => provider.updateController('bodDisAcik', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_doner'),
            label: "Bodrum: ${Bolum20Content.cokKatOption5.uiTitle}",
            ctrl: provider.bodDonerCtrl,
            error: context.select((Bolum20Provider p) => p.bodDonerErr),
            onChange: (val) => provider.updateController('bodDoner', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_sahanliksiz'),
            label: "Bodrum: ${Bolum20Content.cokKatOption6.uiTitle}",
            ctrl: provider.bodSahanliksizCtrl,
            error: context.select((Bolum20Provider p) => p.bodSahanliksizErr),
            onChange: (val) => provider.updateController('bodSahanliksiz', val),
          ),
          const Divider(height: 16),
          _StairInputRow(
            key: const ValueKey('b_dengelenmis'),
            label: "Bodrum: ${Bolum20Content.cokKatOption7.uiTitle}",
            ctrl: provider.bodDengelenmisCtrl,
            error: context.select((Bolum20Provider p) => p.bodDengelenmisErr),
            onChange: (val) => provider.updateController('bodDengelenmis', val),
          ),
        ],
      ),
    );
  }
}

class _StairInputRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String? error;
  final String? assetPath;
  final List<String>? assetPaths;
  final void Function(String)? onChange;

  const _StairInputRow({
    super.key,
    required this.label,
    required this.ctrl,
    this.error,
    this.assetPath,
    this.assetPaths,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 8: Hata mesajını input'un altında değil, labelın altında göster
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: SubQuestionTitle(label),
            ),
            if (assetPath != null) ...[
              const SizedBox(width: 6),
              _buildCameraIcon(context, assetPath!, label),
            ],
            if (assetPaths != null) ...[
              for (var path in assetPaths!) ...[
                const SizedBox(width: 6),
                _buildCameraIcon(context, path, label),
              ]
            ],
            const SizedBox(width: 6),
            SizedBox(
              width: 55,
              child: TextFormField(
                controller: ctrl,

                // FocusNode kaldırıldı - sonsuz rebuild döngüsüne neden oluyordu
                onChanged: onChange,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [InputValidator.positiveInteger],
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  border: OutlineInputBorder(),
                  hintText: "0",
                  // errorText kaldırıldı - aşağıda okunabilir alanda gösteriliyor
                ),
              ),
            ),
          ],
        ),
        // Hata mesajı labelın altında, okunablır font'ta
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(
              error!,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCameraIcon(BuildContext context, String path, String title) {
    return GestureDetector(
      onTap: () => ImageModalHelper.show(context, assetPath: path, title: title),
      child: Tooltip(
        message: 'Görseli İncele',
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF43A047).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.photo_camera,
            color: Color(0xFF2E7D32),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class StairQuestion extends StatelessWidget {
  final Bolum20Provider provider;
  final String title;
  final String keyParam;
  final List<ChoiceResult> options;
  final ChoiceResult? selected;
  final String? definition;
  final String? term;

  const StairQuestion({
    super.key,
    required this.provider,
    required this.title,
    required this.keyParam,
    required this.options,
    this.selected,
    this.definition,
    this.term,
  });

  @override
  Widget build(BuildContext context) {
    return QuestionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (definition != null && term != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.questionTitle,
                  ),
                ),
                DefinitionButton(term: term!, definition: definition!),
              ],
            )
          else
            Text(title, style: AppStyles.questionTitle),
          const SizedBox(height: 12),
          ...options.map(
            (opt) => SelectableCard(
              choice: opt,
              isSelected: selected?.label == opt.label,
              onTap: () {
                if (keyParam == 'bodrum') {
                  final bool isIndependent =
                      opt.label == Bolum20Content.bodrumOptionB.label;
                  provider.setIsBodrumIndependent(isIndependent, opt);
                } else {
                  provider.handleSelection(keyParam, opt);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StairClassificationSummary extends StatelessWidget {
  final Bolum20Provider provider;
  const _StairClassificationSummary({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Merdiven Sınıflandırması (Otomatik Hesaplandı)',
            style: AppStyles.questionTitle,
          ),
          const SizedBox(height: 12),
          Selector<Bolum20Provider, int>(
            selector: (_, p) => p.korunumluMainStairs,
            builder: (context, count, _) => _ClassificationRow(
              key: const ValueKey('korunumlu_row'),
              label: 'Korunumlu Merdiven',
              count: count,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Selector<Bolum20Provider, int>(
            selector: (_, p) => p.korunumsuzMainStairs,
            builder: (context, count, _) => _ClassificationRow(
              key: const ValueKey('korunumsuz_row'),
              label: 'Korunumsuz Merdiven',
              count: count,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassificationRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _ClassificationRow({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1.5),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
