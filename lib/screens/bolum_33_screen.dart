import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../utils/app_content.dart';
import '../../models/choice_result.dart';
import '../../utils/app_theme.dart';

class Bolum33Screen extends StatefulWidget {
  const Bolum33Screen({super.key});

  @override
  State<Bolum33Screen> createState() => _Bolum33ScreenState();

  static double getKatsayi(ChoiceResult? choice) {
    if (choice == null) return 20.0;
    final label = choice.label;
    if (label.contains("10-A")) return 20.0;
    if (label.contains("10-B")) return 10.0;
    if (label.contains("10-C")) return 5.0;
    if (label.contains("10-D")) return 1.5;
    if (label.contains("10-E")) return 30.0;
    return 20.0;
  }

  static int hesaplaGerekliCikis(int kisi) {
    if (kisi <= 50) return 1;
    if (kisi <= 500) return 2;
    if (kisi <= 1000) return 3;
    return 4 + ((kisi - 1000) / 500).ceil();
  }

  static void recalculateAndSaveUserLoads(BinaStore store) {
    final b3 = store.bolum3;
    final b5 = store.bolum5;
    final b10 = store.bolum10;
    final b13 = store.bolum13;
    final b20 = store.bolum20;
    final b34 = store.bolum34;

    bool hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
    bool hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;
    double hYapi = b3?.hYapi ?? 0.0;

    bool isExcluded(ChoiceResult? choice, ChoiceResult? kapiSecimi, ChoiceResult? b34Secimi, String b34Target) {
      if (choice == null) return false;
      bool isTicari = choice.uiTitle.toLowerCase().contains("ticari");
      if (!isTicari) return false;
      bool excludedBy13 = kapiSecimi?.label.contains("13-11-C") ?? false;
      bool excludedBy34 = false;
      if (b34?.areTicariCikisSame == true) {
        // Tüm katlar için aynı cevap geçerli; paylaşımlı label "34-1-A" gibi
        // olabilir, ama "-A" ile biten her label "bağımsız çıkış VAR" anlamına gelir.
        final shared = b34?.zemin ?? b34?.bodrum ?? b34?.normal;
        excludedBy34 = shared?.label.endsWith("-A") ?? false;
      } else {
        excludedBy34 = b34Secimi?.label.contains(b34Target) ?? false;
      }
      return excludedBy13 || excludedBy34;
    }

    ChoiceResult? b34Zemin = b34?.areTicariCikisSame == true
        ? (b34?.zemin ?? b34?.bodrum ?? b34?.normal)
        : b34?.zemin;
    ChoiceResult? b34Normal = b34?.areTicariCikisSame == true
        ? (b34?.zemin ?? b34?.bodrum ?? b34?.normal)
        : b34?.normal;
    ChoiceResult? b34Bodrum = b34?.areTicariCikisSame == true
        ? (b34?.zemin ?? b34?.bodrum ?? b34?.normal)
        : b34?.bodrum;

    // 1. ZEMİN KAT
    double alanZemin = b5?.tabanAlani ?? 0.0;
    int yukZemin = 0;
    int gZemin = 0;
    if (isExcluded(b10?.zemin, b13?.ticariKapiZemin, b34Zemin, "34-1-A")) {
      yukZemin = 0;
      gZemin = 0;
    } else {
      double kZemin = getKatsayi(b10?.zemin);
      yukZemin = (alanZemin / kZemin).ceil();
      int gZeminLoad = hesaplaGerekliCikis(yukZemin);
      gZemin = (hYapi >= 21.50) ? math.max(gZeminLoad, 2) : gZeminLoad;
    }

    // 2. NORMAL KAT
    double alanNormal = b5?.normalKatAlani ?? 0.0;
    int yukNormal = 0;
    if (b10 != null && b10.normaller.isNotEmpty) {
      for (var choice in b10.normaller) {
        if (isExcluded(choice, b13?.ticariKapiNormal, b34Normal, "34-3-A")) continue;
        double k = getKatsayi(choice);
        int yuk = (alanNormal / k).ceil();
        if (yuk > yukNormal) yukNormal = yuk;
      }
    } else {
      yukNormal = (alanNormal / getKatsayi(null)).ceil();
    }
    int gNormal = 0;
    if (yukNormal > 0) {
      int gNormalLoad = hesaplaGerekliCikis(yukNormal);
      gNormal = (hYapi >= 21.50) ? math.max(gNormalLoad, 2) : gNormalLoad;
    }

    // 3. BODRUM KAT
    double alanBodrum = b5?.bodrumKatAlani ?? 0.0;
    int yukBodrum = 0;
    if (b10 != null && b10.bodrumlar.isNotEmpty) {
      for (var choice in b10.bodrumlar) {
        if (isExcluded(choice, b13?.ticariKapiBodrum, b34Bodrum, "34-2-A")) continue;
        double k = getKatsayi(choice);
        int yuk = (alanBodrum / k).ceil();
        if (yuk > yukBodrum) yukBodrum = yuk;
      }
    } else {
      yukBodrum = (alanBodrum / getKatsayi(null)).ceil();
    }
    int gBodrum = 0;
    if (yukBodrum > 0) {
      int gBodrumLoad = hesaplaGerekliCikis(yukBodrum);
      gBodrum = (hYapi >= 21.50) ? math.max(gBodrumLoad, 2) : gBodrumLoad;
    }

    // 4. MEVCUT ÇIKIŞ SAYILARI
    int mevcutUst =
        (b20?.normalMerdivenSayisi ?? 0) +
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
        (b20?.donerMerdivenSayisi ?? 0) +
        (b20?.sahanliksizMerdivenSayisi ?? 0) +
        (b20?.dengelenmisMerdivenSayisi ?? 0);

    int mevcutBodrum = 0;
    bool isBodrumIndependent = b20?.isBodrumIndependent ?? false;
    if (isBodrumIndependent) {
      mevcutBodrum =
          (b20?.bodrumNormalMerdivenSayisi ?? 0) +
          (b20?.bodrumBinaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumDonerMerdivenSayisi ?? 0) +
          (b20?.bodrumSahanliksizMerdivenSayisi ?? 0) +
          (b20?.bodrumDengelenmisMerdivenSayisi ?? 0);
    } else {
      mevcutBodrum = (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A") ? mevcutUst : 0;
    }

    var newModel = store.bolum33 ?? Bolum33Model();
    store.bolum33 = newModel.copyWith(
      alanZemin: alanZemin,
      alanNormal: hasNormal ? alanNormal : null,
      alanBodrumMax: hasBodrum ? alanBodrum : null,
      yukZemin: yukZemin,
      yukNormal: hasNormal ? yukNormal : null,
      yukBodrum: hasBodrum ? yukBodrum : null,
      gerekliZemin: gZemin,
      gerekliNormal: hasNormal ? gNormal : null,
      gerekliBodrum: hasBodrum ? gBodrum : null,
      mevcutUst: mevcutUst,
      mevcutBodrum: hasBodrum ? mevcutBodrum : null,
    );
  }
}

class _Bolum33ScreenState extends State<Bolum33Screen> {
  Bolum33Model _model = Bolum33Model();
  bool _isConfirmed = false;
  String _specialWarning = "";

  // Kat varlık kontrolleri
  bool _hasNormal = false;
  bool _hasBodrum = false;

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum33 != null) {
      _model = BinaStore.instance.bolum33!;
      _isConfirmed = true; // Confirmation load
    }
    _hesapla();
  }

  void _hesapla() {
    final store = BinaStore.instance;
    // Arka plan fonksiyonumuzu çağırıp State'i güncelliyoruz
    Bolum33Screen.recalculateAndSaveUserLoads(store);
    
    // UI state'i güncelle
    if (store.bolum33 != null) {
      setState(() {
        _model = store.bolum33!;
        _hasNormal = (store.bolum3?.normalKatSayisi ?? 0) >= 1;
        _hasBodrum = (store.bolum3?.bodrumKatSayisi ?? 0) >= 1;
        
        bool hasSprinkler = store.bolum9?.secim?.label == "9-A";
        double alanNormal = _model.alanNormal ?? 0.0;
        int gNormal = _model.gerekliNormal ?? 0;
        
        if (gNormal == 1) {
          if (hasSprinkler && alanNormal > 450) {
            _specialWarning =
                "Normal kat alanı belli büyüklüğün üzerindedir. Bu sebeple, binada sprinkler olsa bile tek yön kaçış mesafesinin (30m) aşılma ihtimali var. İkinci çıkış gereksinimi doğabilir. Uzman kontrolü tavsiye edilir.";
          } else if (!hasSprinkler && alanNormal > 600) {
            _specialWarning =
                "Normal kat alanı belli büyüklüğün üzerindedir. Tek yön kaçış mesafesi aşılabilir. 2. çıkış gerekebilir.";
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kullanıcı Yükü",
      screenType: widget.runtimeType,
      isNextEnabled: _isConfirmed,
      onNext: () {
        BinaStore.instance.bolum33 = _model;
        BinaStore.instance.saveToDisk();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum34Screen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Katlardaki kullanıcı yükleri (tahmini).",
                  style: AppStyles.questionTitle,
                ),
              ),
              const SizedBox(width: 8),
              DefinitionButton(
                term: "Kullanıcı Yükü",
                definition: AppDefinitions.kullaniciYuku,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryCard(
            "ZEMİN KAT",
            _model.yukZemin,
            _model.gerekliZemin,
            _model.mevcutUst,
            _model.zeminKatSonuc,
          ),
          if (_hasNormal)
            _buildSummaryCard(
              "NORMAL KATLAR",
              _model.yukNormal,
              _model.gerekliNormal,
              _model.mevcutUst,
              _model.normalKatSonuc,
            ),
          if (_hasBodrum)
            _buildSummaryCard(
              "BODRUM KATLAR",
              _model.yukBodrum,
              _model.gerekliBodrum,
              _model.mevcutBodrum,
              _model.bodrumKatSonuc,
            ),

          if (_specialWarning.isNotEmpty)
            CustomInfoNote(
              type: InfoNoteType.warning,
              text: _specialWarning,
              icon: Icons.warning_amber_rounded,
            ),

          if (_hasBodrum || _hasNormal)
            Builder(builder: (context) {
              final b10 = BinaStore.instance.bolum10;
              bool hasTicariArea = false;
              if (b10 != null) {
                hasTicariArea =
                    b10.bodrumlar.whereType<ChoiceResult>().any((c) => c.uiTitle.toLowerCase().contains("ticari")) ||
                    b10.normaller.whereType<ChoiceResult>().any((c) => c.uiTitle.toLowerCase().contains("ticari")) ||
                    (b10.zemin?.uiTitle.toLowerCase().contains("ticari") ?? false);
              }
              if (!hasTicariArea) return const SizedBox.shrink();
              return CustomInfoNote(
                type: InfoNoteType.info,
                icon: Icons.sync_outlined,
                text:
                    "Bir sonraki adımda (Bölüm 34) ticari alanların bağımsız çıkışlarını belirtmeniz halinde, bu tablodaki kullanıcı yükü hesabı otomatik olarak güncellenir ve nihai rapordaki değerler buna göre düzenlenir.",
              );
            }),

          ConfirmationCheckbox(
            value: _isConfirmed,
            onChanged: (v) => setState(() => _isConfirmed = v ?? false),
            text: "Hesaplanan değerleri okudum, onaylıyorum.",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int? yuk,
    int? gerekli,
    int? mevcut,
    ChoiceResult? sonuc,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.questionTitle),
          const Divider(),
          _buildRow("Kullanıcı Yükü:", "$yuk Kişi"),
          _buildRow("Gereken Merdiven:", "$gerekli Adet"),
          _buildRow("Mevcut Merdiven:", "$mevcut Adet"),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
