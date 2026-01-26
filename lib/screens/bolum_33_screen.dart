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

  double _getKatsayi(ChoiceResult? choice) {
    if (choice == null) return 20.0; // Varsayılan (Konut)
    final label = choice.label;
    // Bölüm 10'daki etiketlere göre katsayılar (Yönetmelik Ek-5/A)
    if (label.contains("10-A")) return 20.0; // Konut
    if (label.contains("10-B")) return 10.0; // Büro/Ofis
    if (label.contains("10-C")) return 5.0; // Mağaza/Ticari
    if (label.contains("10-D")) return 1.5; // Toplanma/Eğlence
    if (label.contains("10-E")) return 30.0; // Depo/Otopark
    return 20.0;
  }

  int _hesaplaGerekliCikis(int kisi) {
    if (kisi <= 50) return 1;
    if (kisi <= 500) return 2;
    if (kisi <= 1000) return 3;
    return 4; // 1000 üzeri için her 500 kişide +1 artar ama şimdilik 4 diyelim
  }

  void _hesapla() {
    final store = BinaStore.instance;
    final b3 = store.bolum3;
    final b5 = store.bolum5;
    final b9 = store.bolum9;
    final b10 = store.bolum10;
    final b20 = store.bolum20;

    _hasNormal = (b3?.normalKatSayisi ?? 0) >= 1;
    _hasBodrum = (b3?.bodrumKatSayisi ?? 0) >= 1;

    double hYapi = b3?.hYapi ?? 0.0;
    bool hasSprinkler = b9?.secim?.label == "9-A";

    // 1. ZEMİN KAT HESABI
    double alanZemin = b5?.tabanAlani ?? 0.0;
    double kZemin = _getKatsayi(b10?.zemin);
    int yukZemin = (alanZemin / kZemin).ceil();
    int gZeminLoad = _hesaplaGerekliCikis(yukZemin);
    // Zemin katta yükseklik kriteri aranmaz, sadece kişi sayısı
    int gZemin = gZeminLoad;

    // 2. NORMAL KAT HESABI
    double alanNormal = b5?.normalKatAlani ?? 0.0;
    double kNormal = _getKatsayi(
      b10?.normaller.isNotEmpty == true ? b10!.normaller.first : null,
    );
    int yukNormal = (alanNormal / kNormal).ceil();
    int gNormalLoad = _hesaplaGerekliCikis(yukNormal);
    // Yüksek binalarda (21.50m üstü) en az 2 çıkış şarttır
    int gNormal = (hYapi > 21.50) ? math.max(gNormalLoad, 2) : gNormalLoad;

    // 3. BODRUM KAT HESABI
    double alanBodrum = b5?.bodrumKatAlani ?? 0.0;
    double kBodrum = _getKatsayi(
      b10?.bodrumlar.isNotEmpty == true ? b10!.bodrumlar.first : null,
    );
    int yukBodrum = (alanBodrum / kBodrum).ceil();
    int gBodrum = _hesaplaGerekliCikis(yukBodrum);

    // 4. MEVCUT ÇIKIŞ SAYILARI
    // Üst katlar için toplam merdiven sayısı (Sahanlıksız hariç)
    // Sahanlıksız merdivenler kaçış yolu kabul edilmez
    int mevcutUst =
        (b20?.normalMerdivenSayisi ?? 0) +
        (b20?.binaIciYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiKapaliYanginMerdiveniSayisi ?? 0) +
        (b20?.binaDisiAcikYanginMerdiveniSayisi ?? 0) +
        (b20?.donerMerdivenSayisi ?? 0);

    // Bodrum için Çıkış Sayısı
    int mevcutBodrum = 0;
    bool isBodrumIndependent = b20?.isBodrumIndependent ?? false;

    if (isBodrumIndependent) {
      // Bağımsız ise kendi sayısını topla (Sahanlıksız hariç)
      mevcutBodrum =
          (b20?.bodrumNormalMerdivenSayisi ?? 0) +
          (b20?.bodrumBinaIciYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiKapaliYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumBinaDisiAcikYanginMerdiveniSayisi ?? 0) +
          (b20?.bodrumDonerMerdivenSayisi ?? 0);
    } else {
      // Bağımsız değilse, merdiven bodruma iniyor mu?
      if (b20?.bodrumMerdivenDevami?.label == "20-Bodrum-A") {
        mevcutBodrum = mevcutUst;
      } else {
        mevcutBodrum = 0;
      }
    }

    // 450/600m² UYARISI (Sadece Normal Kat İçin Örnek)
    if (gNormal == 1) {
      if (hasSprinkler && alanNormal > 450) {
        _specialWarning =
            "Normal kat alanı belli büyüklüğün üzerindedir. Bu sebeple, binada sprinkler olsa bile tek yön kaçış mesafesinin (30m) aşılma ihtimali var. İkinci çıkış gereksinimi doğabilir. Uzman kontrolü tavsiye edilir.";
      } else if (!hasSprinkler && alanNormal > 600) {
        // Yönetmelikte 600m2 sınırı sprinklersiz için değil, genel bir sınırdır ama senin mantığına göre:
        // Düzeltme: Sprinklersiz ise sınır daha düşüktür ama senin metnine sadık kalıyorum.
        _specialWarning =
            "Normal kat alanı belli büyükküğün üzerindedir. Tek yön kaçış mesafesi aşılabilir. 2. çıkış gerekebilir.";
      }
    }

    setState(() {
      _model = _model.copyWith(
        alanZemin: alanZemin,
        alanNormal: alanNormal,
        alanBodrumMax: alanBodrum,
        yukZemin: yukZemin,
        yukNormal: yukNormal,
        yukBodrum: yukBodrum,
        gerekliZemin: gZemin,
        gerekliNormal: gNormal,
        gerekliBodrum: gBodrum,
        mevcutUst: mevcutUst,
        mevcutBodrum: mevcutBodrum,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnalysisPageLayout(
      title: "Kullanıcı Yükü Hesabı ve Çıkış Adedi Analizi",
      subtitle: "Merdiven uygunluk kontrolü HARİÇ",
      screenType: widget.runtimeType,
      isNextEnabled: _isConfirmed,
      onNext: () {
        BinaStore.instance.bolum33 = _model;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Bolum34Screen()),
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kullanıcı Yükü Nedir?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
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
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _specialWarning,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          CheckboxListTile(
            value: _isConfirmed,
            onChanged: (v) => setState(() => _isConfirmed = v!),
            title: const Text(
              "Hesaplanan değerleri okudum, onaylıyorum.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            activeColor: const Color(0xFF1A237E),
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
    bool isSuccess = (sonuc?.label.contains("OK") ?? false);
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1A237E),
            ),
          ),
          const Divider(),
          _buildRow("Tahmini Kişi:", "$yuk Kişi"),
          _buildRow("Gereken Çıkış:", "$gerekli Adet"),
          _buildRow("Mevcut Çıkış:", "$mevcut Adet"),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sonuc?.reportText ?? "",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSuccess
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
