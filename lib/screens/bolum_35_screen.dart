import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_35_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_36_screen.dart';
class Bolum35Screen extends StatefulWidget {
  const Bolum35Screen({super.key});

  @override
  State<Bolum35Screen> createState() => _Bolum35ScreenState();
}

class _Bolum35ScreenState extends State<Bolum35Screen> {
  Bolum35Model _model = Bolum35Model();
  
  // Controllerlar
  final TextEditingController _tekYonCtrl = TextEditingController();
  final TextEditingController _ciftYonCtrl = TextEditingController();
  final TextEditingController _cikmazCtrl = TextEditingController();

  // Limitler (InitState'de hesaplanacak)
  double _limitTekYon = 15.0;
  double _limitCiftYon = 30.0;
  bool _isTekCikisli = true;

  @override
  void initState() {
    super.initState();
    _calculateLimits();

    if (BinaStore.instance.bolum35 != null) {
      _model = BinaStore.instance.bolum35!;
      if (_model.valMesafeTekYon != null) _tekYonCtrl.text = _model.valMesafeTekYon.toString();
      if (_model.valMesafeCiftYon != null) _ciftYonCtrl.text = _model.valMesafeCiftYon.toString();
      if (_model.valMesafeCikmaz != null) _cikmazCtrl.text = _model.valMesafeCikmaz.toString();
    }
  }

  void _calculateLimits() {
    final bool hasSprinkler = BinaStore.instance.bolum9?.hasSprinkler ?? false;
    final int cikisSayisi = BinaStore.instance.bolum33?.valMevcutCikisUst ?? 1;

    setState(() {
      _limitTekYon = hasSprinkler ? 30.0 : 15.0;
      _limitCiftYon = hasSprinkler ? 75.0 : 30.0;
      _isTekCikisli = cikisSayisi <= 1;
    });
  }

  @override
  void dispose() {
    _tekYonCtrl.dispose();
    _ciftYonCtrl.dispose();
    _cikmazCtrl.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (!_isFormValid()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK BİLGİ"),
          content: const Text("Lütfen durumunuza uygun mesafe bilgisini giriniz veya seçiniz."),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tamam"))],
        ),
      );
      return;
    }

    BinaStore.instance.bolum35 = _model;
    print("Bölüm 35 Kaydedildi.");
    
    // FİNAL: SONUÇ EKRANINA GİT
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum36Screen()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ANALİZ TAMAMLANDI! Rapor oluşturuluyor...")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Kaçış Mesafeleri",
            subtitle: "Bölüm 35: Uzaklık Kontrolü",
            currentStep: 35,
            totalSteps: 35,
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isTekCikisli) _buildSenaryo1() else _buildSenaryo2(),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  // SENARYO 1: TEK ÇIKIŞLI BİNALAR
  Widget _buildSenaryo1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("SENARYO 1: TEK YÖN MESAFE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        const Text(
          "Binanızda tek bir kaçış yolu olduğu için, evinizin en uzak noktasından bina merdiven kapısına kadar olan mesafe kaç metredir?",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard<ChoiceResult>(
                title: "A) Tam ölçüyü biliyorum.",
                value: ChoiceResult(label: "A", reportText: "Manuel Giriş"),
                groupValue: _model.resMesafeTekYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeTekYon: val)),
              ),
              if (_model.resMesafeTekYon?.label == "A")
                _buildDecimalField("Ölçülen Mesafe", _tekYonCtrl, _limitTekYon, (v) => setState(() => _model = _model.copyWith(valMesafeTekYon: double.tryParse(v)))),
              
              SelectableCard<ChoiceResult>(
                title: "B) Tahminen $_limitTekYon metreden KISADIR.",
                subtitle: "✅ OLUMLU",
                value: ChoiceResult(label: "B", reportText: "✅ OLUMLU. Mesafe sınırın altında."),
                groupValue: _model.resMesafeTekYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeTekYon: val, valMesafeTekYon: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "C) Tahminen $_limitTekYon metreden UZUNDUR.",
                subtitle: "🚨 RİSK: Sınır aşıldı.",
                value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Tek yön kaçış mesafesi sınırın üzerinde!"),
                groupValue: _model.resMesafeTekYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeTekYon: val, valMesafeTekYon: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "D) Bilmiyorum.",
                value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Mesafe ölçülmelidir."),
                groupValue: _model.resMesafeTekYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeTekYon: val, valMesafeTekYon: null)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SENARYO 2: ÇOK ÇIKIŞLI BİNALAR
  Widget _buildSenaryo2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("ADIM A: EN YAKIN ÇIKIŞA MESAFE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        const Text(
          "Daire kapınızdan çıktığınızda, size EN YAKIN olan yangın merdivenine (veya çıkışa) mesafe kaç metredir?",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard<ChoiceResult>(
                title: "A) Tam ölçüyü biliyorum.",
                value: ChoiceResult(label: "A", reportText: "Manuel Giriş"),
                groupValue: _model.resMesafeCiftYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCiftYon: val)),
              ),
              if (_model.resMesafeCiftYon?.label == "A")
                _buildDecimalField("Ölçülen Mesafe", _ciftYonCtrl, _limitCiftYon, (v) => setState(() => _model = _model.copyWith(valMesafeCiftYon: double.tryParse(v)))),

              SelectableCard<ChoiceResult>(
                title: "B) Tahminen $_limitCiftYon metreden KISADIR.",
                subtitle: "✅ OLUMLU",
                value: ChoiceResult(label: "B", reportText: "✅ OLUMLU. En yakın çıkış mesafesi uygun."),
                groupValue: _model.resMesafeCiftYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCiftYon: val, valMesafeCiftYon: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "C) Tahminen $_limitCiftYon metreden UZUNDUR.",
                subtitle: "🚨 RİSK: Sınır aşıldı.",
                value: ChoiceResult(label: "C", reportText: "🚨 RİSK. En yakın çıkışa mesafe sınırın üzerinde!"),
                groupValue: _model.resMesafeCiftYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCiftYon: val, valMesafeCiftYon: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "D) Bilmiyorum.",
                value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Mesafe ölçülmelidir."),
                groupValue: _model.resMesafeCiftYon,
                onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCiftYon: val, valMesafeCiftYon: null)),
              ),
            ],
          ),
        ),

        const Divider(height: 40),
        const Text("ADIM B: ÇIKMAZ KORİDOR DURUMU", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 8),
        const Text(
          "Daireniz koridorun sonunda, 'Çıkmaz' bir noktada mı? (Sadece tek yöne gidilebiliyor mu?)",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),
        QuestionCard(
          child: Column(
            children: [
              SelectableCard<ChoiceResult>(
                title: "A) Hayır, iki yöne de gidebiliyorum.",
                subtitle: "✅ OLUMLU",
                value: ChoiceResult(label: "A", reportText: "✅ OLUMLU. Çıkmaz koridor yok."),
                groupValue: _model.hasCikmazKoridor,
                onChanged: (val) => setState(() => _model = _model.copyWith(hasCikmazKoridor: val, resMesafeCikmaz: null, valMesafeCikmaz: null)),
              ),
              SelectableCard<ChoiceResult>(
                title: "B) Evet, çıkmaz koridorun ucundayım.",
                value: ChoiceResult(label: "B", reportText: "Çıkmaz koridor mevcut."),
                groupValue: _model.hasCikmazKoridor,
                onChanged: (val) => setState(() => _model = _model.copyWith(hasCikmazKoridor: val)),
              ),
              
              // ADIM C: ÇIKMAZ MESAFESİ
              if (_model.hasCikmazKoridor?.label == "B") ...[
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Alt Soru: Yol ayrımına kadar mesafe ne kadar?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                ),
                SelectableCard<ChoiceResult>(
                  title: "A) Tam ölçüyü biliyorum.",
                  value: ChoiceResult(label: "A", reportText: "Manuel Giriş"),
                  groupValue: _model.resMesafeCikmaz,
                  onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCikmaz: val)),
                ),
                if (_model.resMesafeCikmaz?.label == "A")
                  _buildDecimalField("Ölçülen Mesafe", _cikmazCtrl, _limitTekYon, (v) => setState(() => _model = _model.copyWith(valMesafeCikmaz: double.tryParse(v)))),

                SelectableCard<ChoiceResult>(
                  title: "B) Tahminen $_limitTekYon metreden KISADIR.",
                  subtitle: "✅ OLUMLU",
                  value: ChoiceResult(label: "B", reportText: "✅ OLUMLU. Çıkmaz koridor mesafesi uygun."),
                  groupValue: _model.resMesafeCikmaz,
                  onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCikmaz: val, valMesafeCikmaz: null)),
                ),
                SelectableCard<ChoiceResult>(
                  title: "C) Tahminen $_limitTekYon metreden UZUNDUR.",
                  subtitle: "🚨 RİSK: Kaçış zorlaşır.",
                  value: ChoiceResult(label: "C", reportText: "🚨 RİSK. Çıkmaz koridor mesafesi sınırın üzerinde!"),
                  groupValue: _model.resMesafeCikmaz,
                  onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCikmaz: val, valMesafeCikmaz: null)),
                ),
                SelectableCard<ChoiceResult>(
                  title: "D) Bilmiyorum.",
                  value: ChoiceResult(label: "D", reportText: "❓ BİLİNMİYOR. Çıkmaz koridor mesafesi bilinmiyor."),
                  groupValue: _model.resMesafeCikmaz,
                  onChanged: (val) => setState(() => _model = _model.copyWith(resMesafeCikmaz: val, valMesafeCikmaz: null)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecimalField(String label, TextEditingController ctrl, double limit, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (val) {
          onChanged(val);
          double? v = double.tryParse(val);
          if (v != null && v > limit) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dikkat: Girdiğiniz değer limitin ($limit m) üzerinde!"), duration: const Duration(seconds: 1)));
          }
        },
        decoration: InputDecoration(
          labelText: label,
          suffixText: "m",
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isFormValid() ? _onNextPressed : null,
            child: const Text("ANALİZİ TAMAMLA"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_isTekCikisli) {
      if (_model.resMesafeTekYon == null) return false;
      if (_model.resMesafeTekYon?.label == "A" && _model.valMesafeTekYon == null) return false;
    } else {
      if (_model.resMesafeCiftYon == null) return false;
      if (_model.resMesafeCiftYon?.label == "A" && _model.valMesafeCiftYon == null) return false;
      
      if (_model.hasCikmazKoridor == null) return false;
      if (_model.hasCikmazKoridor?.label == "B") {
        if (_model.resMesafeCikmaz == null) return false;
        if (_model.resMesafeCikmaz?.label == "A" && _model.valMesafeCikmaz == null) return false;
      }
    }
    return true;
  }
}