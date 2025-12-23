import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart'; // EKLENDİ
import 'package:life_safety/models/bolum_8_model.dart';
import 'package:life_safety/screens/bolum_9_screen.dart';
import 'package:life_safety/widgets/custom_widgets.dart'; // ModernHeader ve SelectableCard

class Bolum8Screen extends StatefulWidget {
  const Bolum8Screen({super.key});

  @override
  State<Bolum8Screen> createState() => _Bolum8ScreenState();
}

class _Bolum8ScreenState extends State<Bolum8Screen> {
  Bolum8Model _model = Bolum8Model();

  @override
  void initState() {
    super.initState();
    // Hafızadaki veriyi geri yükle
    if (BinaStore.instance.bolum8 != null) {
      _model = BinaStore.instance.bolum8!;
    }
  }

  void _handleSelection(NizamDurumu? value) {
    setState(() {
      _model = _model.copyWith(secim: value);
    });
  }

  void _onNextPressed() {
    if (_model.secim == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("⚠️ EKSİK BİLGİ!"),
          content: const Text(
              "Yangın güvenliği analizinde, binanızın komşu binalara olan mesafesi (bitişik olup olmadığı) kritik bir faktördür. Lütfen binanızın 'Ayrık' mı yoksa 'Bitişik' nizam mı olduğunu işaretleyiniz. Emin değilseniz binanızın cephesine bakarak yan binalara yapışık olup olmadığını kontrol edebilirsiniz."),
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
    BinaStore.instance.bolum8 = _model;
    print("Bölüm 8 Kaydedildi. Nizam Durumu: ${_model.nizamDurumuDeger}");
    
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const Bolum9Screen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. MODERN BAŞLIK
          ModernHeader(
            title: "Nizam Durumu",
            subtitle: "Bölüm 8: Yapılaşma Nizamı",
            currentStep: 8,
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
                    "NİZAM DURUMU",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Binanızın yapılaşma nizamı nedir?",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // SEÇENEKLER (Senin Metinlerinle)
                  SelectableCard<NizamDurumu>(
                    title: "A) Ayrık Nizam",
                    subtitle: "Binanın 4 cephesi de açıktır, yan binalara kesinlikle yapışık değildir.",
                    value: NizamDurumu.ayrik,
                    groupValue: _model.secim,
                    onChanged: _handleSelection,
                  ),
                  
                  SelectableCard<NizamDurumu>(
                    title: "B) Bitişik Nizam",
                    subtitle: "Binanın herhangi bir cephesi yan binaya yapışıktır.",
                    value: NizamDurumu.bitisik,
                    groupValue: _model.secim,
                    onChanged: _handleSelection,
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
}