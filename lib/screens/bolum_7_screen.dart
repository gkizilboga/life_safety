import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_7_model.dart';
import 'package:life_safety/screens/bolum_8_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader

class Bolum7Screen extends StatefulWidget {
  // Constructor'dan parametre kaldırıldı
  const Bolum7Screen({super.key});

  @override
  State<Bolum7Screen> createState() => _Bolum7ScreenState();
}

class _Bolum7ScreenState extends State<Bolum7Screen> {
  Bolum7Model _model = Bolum7Model();

  @override
  void initState() {
    super.initState();
    // AUTO-SYNC: Veriyi Store'dan çek
    final String? otoparkStatus = BinaStore.instance.otoparkStatus;
    
    if (otoparkStatus == "KAPALI OTOPARK") {
      _model = _model.copyWith(hasKapaliOtopark: true, hasHicbiri: false);
    } else {
      _model = _model.copyWith(hasKapaliOtopark: false);
    }
  }

  void _updateSelection({
    bool? kazan,
    bool? asansor,
    bool? asansorDaire,
    bool? cati,
    bool? jenerator,
    bool? elektrik,
    bool? trafo,
    bool? depo,
    bool? cop,
    bool? siginak,
    bool? duvar,
  }) {
    setState(() {
      _model = _model.copyWith(
        hasKazanDairesi: kazan,
        hasAsansorNormal: asansor,
        hasAsansorDairesi: asansorDaire,
        hasCatiArasi: cati,
        hasJeneratorOdasi: jenerator,
        hasElektrikOdasi: elektrik,
        hasTrafoOdasi: trafo,
        hasDepo: depo,
        hasCopOdasi: cop,
        hasSiginak: siginak,
        hasOrtakDuvar: duvar,
        hasHicbiri: false,
      );
    });
  }

  void _toggleHicbiri(bool? value) {
    setState(() {
      if (value == true) {
        _model = _model.copyWith(
          hasHicbiri: true,
          hasKazanDairesi: false,
          hasAsansorNormal: false,
          hasAsansorDairesi: false,
          hasCatiArasi: false,
          hasJeneratorOdasi: false,
          hasElektrikOdasi: false,
          hasTrafoOdasi: false,
          hasDepo: false,
          hasCopOdasi: false,
          hasSiginak: false,
          hasOrtakDuvar: false,
        );
      } else {
        _model = _model.copyWith(hasHicbiri: false);
      }
    });
  }

  void _onNextPressed() {
    if (!_model.isAnySelected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ SEÇİM YAPMANIZ GEREKMEKTEDİR"),
          content: const Text(
              "Lütfen binanızda bulunan farklı amaçlı alanları işaretleyiniz. Eğer listenin tamamını kontrol ettiyseniz ve bu alanlardan hiçbiri binanızda yoksa, en alttaki 'Hiçbiri Yok' seçeneğini işaretleyerek devam ediniz."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
      return;
    }

    _navigateToNext();
  }

  void _navigateToNext() {
    // VERİYİ DEPOYA KAYDET
    BinaStore.instance.bolum7 = _model;
    print("Bölüm 7 Kaydedildi.");

    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const Bolum8Screen())
    );
  }

  @override
  Widget build(BuildContext context) {
    // Veriyi Store'dan çek (UI için)
    final bool isKapaliOtopark = BinaStore.instance.otoparkStatus == "KAPALI OTOPARK";

    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Özel Riskli Hacimler",
            subtitle: "Bölüm 7: Riskli Alan Varlığı",
            currentStep: 7,
            totalSteps: 21,
            onBack: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ÖZEL RİSKLİ HACİM VARLIĞI",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Binanızın içinde aşağıdaki alanlardan hangileri mevcut? (Lütfen olanların hepsini işaretleyiniz)",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  CheckboxListTile(
                    title: const Text("Kapalı Otopark"),
                    subtitle: Text(
                      isKapaliOtopark
                          ? "(Binanızda kapalı otopark olduğunu belirttiğinizden sistem tarafından işaretlenmiştir.)"
                          : "(Binanızda kapalı otopark bulunmadığını belirttiniz.)",
                      style: TextStyle(
                        color: isKapaliOtopark ? Colors.green : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    value: _model.hasKapaliOtopark,
                    onChanged: null,
                    activeColor: Colors.grey,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const Divider(),

                  _buildCheckbox("Kazan Dairesi / Isı Merkezi", _model.hasKazanDairesi, (v) => _updateSelection(kazan: v)),
                  _buildCheckbox("Normal Asansör", _model.hasAsansorNormal, (v) => _updateSelection(asansor: v)),
                  _buildCheckbox("Asansör Makine Dairesi", _model.hasAsansorDairesi, (v) => _updateSelection(asansorDaire: v)),
                  _buildCheckbox("Çatı Arası", _model.hasCatiArasi, (v) => _updateSelection(cati: v)),
                  _buildCheckbox("Jeneratör Odası", _model.hasJeneratorOdasi, (v) => _updateSelection(jenerator: v)),
                  _buildCheckbox("Elektrik Odası / Pano Odası", _model.hasElektrikOdasi, (v) => _updateSelection(elektrik: v)),
                  _buildCheckbox("Yağlı Tip Trafo Odası", _model.hasTrafoOdasi, (v) => _updateSelection(trafo: v)),
                  _buildCheckbox("Ortak Depo / Ardiye / Kiler", _model.hasDepo, (v) => _updateSelection(depo: v)),
                  _buildCheckbox("Çöp Odası / Çöp Şut Odası", _model.hasCopOdasi, (v) => _updateSelection(cop: v)),
                  _buildCheckbox("Sığınak", _model.hasSiginak, (v) => _updateSelection(siginak: v)),
                  _buildCheckbox("Ortak Duvar", _model.hasOrtakDuvar, (v) => _updateSelection(duvar: v)),

                  const Divider(),
                  
                  CheckboxListTile(
                    title: const Text("Binada hiçbiri Yok"),
                    value: _model.hasHicbiri,
                    onChanged: isKapaliOtopark 
                        ? null 
                        : _toggleHicbiri,
                    activeColor: const Color(0xFF1A237E),
                    controlAffinity: ListTileControlAffinity.leading,
                    subtitle: isKapaliOtopark 
                      ? const Text("(Binanızda kapalı otopark olduğu için seçilemez)", style: TextStyle(fontSize: 11, color: Colors.red)) 
                      : null,
                  ),
                ],
              ),
            ),
          ),

          // SABİT BUTON ALANI
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: const Text("DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, void Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: _model.hasHicbiri ? null : onChanged,
      activeColor: const Color(0xFF1A237E),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}