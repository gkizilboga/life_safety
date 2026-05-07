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

  /// Kullanıcı yüküne göre minimum merdiven genişliğini döner (metre).
  static double minMerdivGenisligi(int yuk) {
    if (yuk <= 50) return 0.90;
    if (yuk <= 500) return 1.20;
    if (yuk <= 2000) return 1.50;
    return 2.00;
  }

  /// Merdiven gerektiren katlar için gerekli merdiven adedini hesaplar.
  /// BYKHY Madde 39: 50 kişiye kadar 1, 51-500: 2, 501-1000: 3, 1001-1500: 4
  /// 1500 kişiden fazla ise Genişlik bazlı formül kullanılır.
  static int hesaplaMerdivenSayisi(int yuk) {
    if (yuk <= 0) return 0;
    
    if (yuk <= 1500) {
      if (yuk <= 50) return 1; // Binanın yüksekliği vb. diğer parametreler bunu 2'ye zorlayabilir.
      if (yuk <= 500) return 2;
      if (yuk <= 1000) return 3;
      return 4;
    }
    
    // 1500'ü aşan yüklerde genişlik bazlı hesaplama devreye girer:
    final double totalWidth = yuk * 0.5 / 60.0;
    final double minWidth = minMerdivGenisligi(yuk);
    return (totalWidth / minWidth).ceil();
  }

  /// Doğrudan dışarıya çıkış olan katlar için gerekli kapı adedini hesaplar.
  static int hesaplaKapiSayisi(int yuk) {
    if (yuk <= 0) return 0;
    
    if (yuk <= 1500) {
      if (yuk <= 50) return 1;
      if (yuk <= 500) return 2;
      if (yuk <= 1000) return 3;
      return 4;
    }
    
    // 1500'ü aşan yükler için genişlik bazlı hesap (her kapı min 0.9m)
    return (yuk * 0.5 / 90.0).ceil();
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

    // Çıkış katı etiketi — hangi katın dışarıya doğrudan çıkışı olduğunu belirler
    final String cikisKatiLabel = (store.bolum33?.cikisKati?.label) ?? '';

    bool isExcluded(ChoiceResult? choice, ChoiceResult? kapiSecimi) {
      if (choice == null) return false;
      bool isTicari =
          choice.label.startsWith("10-B") ||
          choice.label.startsWith("10-C") ||
          choice.label.startsWith("10-D");
      if (!isTicari) return false;
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
      // Zemin dışarıya çıkış katıysa kapı formülü, değilse merdiven formülü
      final int gZeminRaw = (cikisKatiLabel == '36-0-A')
          ? hesaplaKapiSayisi(yukZemin)
          : hesaplaMerdivenSayisi(yukZemin);
      gZemin = (hYapi >= 21.50) ? math.max(gZeminRaw, 2) : gZeminRaw;
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
      // Normal kattan dışarıya çıkış varsa kapı formülü, yoksa merdiven formülü
      final int gNormalRaw = (cikisKatiLabel == '36-0-B')
          ? hesaplaKapiSayisi(yukNormal)
          : hesaplaMerdivenSayisi(yukNormal);
      gNormal = (hYapi >= 21.50) ? math.max(gNormalRaw, 2) : gNormalRaw;
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
      // Bodrum dışarıya çıkış katıysa kapı formülü, yoksa merdiven formülü
      final int gBodrumRaw = (cikisKatiLabel == '36-0-C')
          ? hesaplaKapiSayisi(yukBodrum)
          : hesaplaMerdivenSayisi(yukBodrum);
      gBodrum = (hYapi >= 21.50) ? math.max(gBodrumRaw, 2) : gBodrumRaw;
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

    // 5. ÇIKIŞ KATI (DISCHARGE LEVEL) KAPASİTE TRANSFERİ
    // BYKHY: Tahliye katının çıkış kapasitesi, kendisine dökülen üst/alt katların 
    // tahliye ihtiyacından (Gereken Çıkış) daha az olamaz.
    if (cikisKatiLabel == '36-0-A') { // Zemin Kat
      int requiredFromAbove = (hasNormal) ? gNormal : 0;
      int requiredFromBelow = (hasBodrum) ? gBodrum : 0;
      int maxDischarging = math.max(requiredFromAbove, requiredFromBelow);
      if (maxDischarging > gZemin) {
        gZemin = maxDischarging;
      }
    } else if (cikisKatiLabel == '36-0-B') { // Normal Kat
      int requiredFromBelow = math.max(gZemin, (hasBodrum ? gBodrum : 0)); 
      if (requiredFromBelow > gNormal) {
        gNormal = requiredFromBelow;
      }
    } else if (cikisKatiLabel == '36-0-C') { // Bodrum Kat
      int requiredFromAbove = math.max(gNormal, gZemin);
      if (requiredFromAbove > gBodrum) {
        gBodrum = requiredFromAbove;
      }
    }

    // 5. Hesaplamada kullanılan min. merdiven genişliği (en yüksek yük baz alınır)
    final int maxYuk = [
      yukZemin,
      if (hasNormal) yukNormal,
      if (hasBodrum) yukBodrum,
    ].fold(0, math.max);
    final double modelMinMerdivGen = minMerdivGenisligi(
      maxYuk > 0 ? maxYuk : 1,
    );

    var newModel = store.bolum33 ?? Bolum33Model();
    final ChoiceResult? cikisKati = newModel.cikisKati;
    final int cikisSayisi = newModel.cikisSayisi ?? 0;

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
      mevcutBodrum: hasBodrum
          ? ((cikisKati?.label == '36-0-C') ? cikisSayisi : mevcutBodrum)
          : null,
      cikisKati: cikisKati,
      cikisSayisi: cikisSayisi,
      minMerdivGenisligi: modelMinMerdivGen,
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
      // Limit check is removed from logic to prevent blocking, but UI warning remains
      if (val != null && val >= 0) {
        setState(() {
          _isConfirmed = false;
          _model = _model.copyWith(cikisSayisi: val);
        });
        _hesapla();
      } else if (_cikisSayisiCtrl.text.isEmpty) {
        setState(() {
          _isConfirmed = false;
          _model = _model.copyWith(cikisSayisi: 0);
        });
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
    // CRITICAL FIX: Sync _model to store BEFORE calculation to ensure the engine sees the latest inputs
    store.bolum33 = _model;
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
                "Normal kat alanı belli büyüklüğün üzerindedir. Tek yön kaçış mesafesi aşılabilir. İkinci çıkış gerekebilir.";
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
          _model.cikisSayisi != null &&
          _model.cikisSayisi! > 0,
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
                  "Binadan dış havaya (atmosfere) çıktığınız kat hangisidir?",
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
                  "Binadan dışarıya çıkışın bulunduğu katta kaç adet çıkış kapısı var?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E), // Dark Purple/Navy
                  ),
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
                    hintText: "0",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
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
                if (_cikisSayisiCtrl.text.isNotEmpty) ...[
                  if ((int.tryParse(_cikisSayisiCtrl.text) ?? 0) > 75)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 2),
                      child: Text(
                        "Maks. 75 adet girilebilir.",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Katlardaki kullanıcı yükleri (tahmini)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E), // Dark Purple/Navy
                  ),
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
            _model.mevcutZemin, // computed getter: zemin'e özel mevcut çıkış
            _model.zeminKatSonuc,
          ),
          if (_hasNormal)
            _buildSummaryCard(
              "NORMAL KATLAR",
              _model.yukNormal,
              _model.gerekliNormal,
              _model
                  .mevcutNormal, // computed getter: normal'e özel mevcut çıkış
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
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
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
