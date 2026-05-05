import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../data/bina_store.dart';
import '../../models/bolum_33_model.dart';
import 'bolum_34_screen.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
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

    bool hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
    bool hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;
    double hYapi = b3?.hYapi ?? 0.0;

    bool isExcluded(ChoiceResult? choice, ChoiceResult? kapiSecimi) {
      if (choice == null) return false;
      bool isTicari =
          choice.label.startsWith("10-B") ||
          choice.label.startsWith("10-C") ||
          choice.label.startsWith("10-D");
      if (!isTicari) return false;

      // Eğer Bölüm 13'te "Geçiş Yok" (13-11-C) seçilmişse, bu alan bağımsız
      // çıkışlı kabul edilir ve konut merdiveni yüküne dahil edilmez.
      return kapiSecimi?.label.contains("13-11-C") ?? false;
    }

    // 1. ZEMİN KAT
    double alanZemin = b5?.tabanAlani ?? 0.0;
    int yukZemin = 0;
    int gZemin = 0;
    if (isExcluded(b10?.zemin, b13?.ticariKapiZemin)) {
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
        if (isExcluded(choice, b13?.ticariKapiNormal)) continue;
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
        if (isExcluded(choice, b13?.ticariKapiBodrum)) continue;
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
      mevcutBodrum = (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A")
          ? mevcutUst
          : 0;
    }

    var newModel = store.bolum33 ?? Bolum33Model();
    final ChoiceResult? cikisKati = newModel.cikisKati;
    final int cikisSayisi = newModel.cikisSayisi ?? 0;

    // Sonuçları modele ata
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
      // Çıkış katı ise manuel girişi, değilse merdiven sayısını baz al
      mevcutUst: (cikisKati?.label == "36-0-A" || cikisKati?.label == "36-0-B")
          ? cikisSayisi
          : mevcutUst,
      mevcutBodrum: hasBodrum
          ? ((cikisKati?.label == "36-0-C") ? cikisSayisi : mevcutBodrum)
          : null,
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

  final TextEditingController _cikisSayisiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (BinaStore.instance.bolum33 != null) {
      _model = BinaStore.instance.bolum33!;
      _isConfirmed = true; // Confirmation load
      if (_model.cikisSayisi != null) {
        _cikisSayisiCtrl.text = _model.cikisSayisi.toString();
      }
    } else {
      // Varsayılan olarak Zemin Katı çıkış katı seçelim (kullanıcı dostu olması için)
      _model = _model.copyWith(cikisKati: Bolum36Content.cikisKatiOptionA);
    }
    _hesapla();

    _cikisSayisiCtrl.addListener(() {
      final val = int.tryParse(_cikisSayisiCtrl.text);
      if (val != null && val >= 0 && val <= 20) {
        setState(() {
          _isConfirmed = false;
        });
        _model = _model.copyWith(cikisSayisi: val);
        _hesapla();
      }
    });
  }

  @override
  void dispose() {
    _cikisSayisiCtrl.dispose();
    super.dispose();
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
      isNextEnabled:
          _isConfirmed &&
          _model.cikisKati != null &&
          _model.cikisSayisi != null,
      customWarningText:
          "Lütfen çıkış katını ve kattaki toplam çıkış sayısını girerek hesaplamaları onaylayınız.",
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
          const SizedBox(height: 12),

          QuestionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Binadan dış havaya çıktığınız kat hangisidir?",
                  style: AppStyles.questionTitle,
                ),
                const SizedBox(height: 12),
                ...[
                  Bolum36Content.cikisKatiOptionA,
                  if ((BinaStore.instance.bolum3?.normalKatSayisi ?? 0) > 0)
                    Bolum36Content.cikisKatiOptionB,
                  if ((BinaStore.instance.bolum3?.bodrumKatSayisi ?? 0) > 0)
                    Bolum36Content.cikisKatiOptionC,
                ].map(
                  (opt) => SelectableCard(
                    choice: opt,
                    isSelected: _model.cikisKati?.label == opt.label,
                    onTap: () {
                      setState(() {
                        _isConfirmed = false;
                        _model = _model.copyWith(cikisKati: opt);
                        BinaStore.instance.bolum33 =
                            _model; // Bug fix: sync with store
                      });
                      _hesapla();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Binadan çıkış katında toplam kaç adet dışarı çıkış kapısı var?",
                  style: AppStyles.questionTitle,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _cikisSayisiCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                  decoration: InputDecoration(
                    hintText: "0-20 arası",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primaryBlue,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                if (_cikisSayisiCtrl.text.isNotEmpty &&
                    (int.tryParse(_cikisSayisiCtrl.text) ?? -1) > 20)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      "Sayı 20'den büyük olamaz.",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Katlardaki kullanıcı yükleri (tahmini)",
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
          _buildRow("Gereken Çıkış:", "$gerekli Adet"),
          _buildRow("Mevcut Çıkış:", "$mevcut Adet"),
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
