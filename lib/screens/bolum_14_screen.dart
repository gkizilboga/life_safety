import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_14_model.dart';
import '../../models/bolum_3_model.dart';
import 'bolum_15_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';

class Bolum14Screen extends StatefulWidget {
  const Bolum14Screen({super.key});

  @override
  State<Bolum14Screen> createState() => _Bolum14ScreenState();
}

class _Bolum14ScreenState extends State<Bolum14Screen> {
  Bolum14Model _model = Bolum14Model();

  @override
  void initState() {
    super.initState();
    _hesaplaVeAnalizEt();
  }

  void _hesaplaVeAnalizEt() {
    // Bölüm 3'ten bina boyutlarını çek
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    // Değerleri al (yoksa varsayılan ata)
    // h_bina aslında Zemin + Normal katlardır ama Bolum3 modelinde toplamYukseklik tüm binayı verir.
    // Yönetmelik h_bina için Zemin+Normal katları kasteder.
    // Manuel hesaplayalım:
    double zeminH = bolum3?.zeminKatYuksekligi ?? 3.50;
    double normalH = bolum3?.normalKatYuksekligi ?? 3.00;
    double bodrumH = bolum3?.bodrumKatYuksekligi ?? 3.50;
    
    int nKat = bolum3?.normalKatSayisi ?? 0;
    int bKat = bolum3?.bodrumKatSayisi ?? 0;

    double hBinaYonetmelik = zeminH + (nKat * normalH); // Yerden çatıya kadar (bodrum hariç)
    double hBodrum = bKat * bodrumH; // Toplam bodrum derinliği

    int duvarDk = 60;
    int kapakDk = 30;
    String mesaj = "";

    // ALGORİTMA
    if (hBinaYonetmelik >= 30.50) {
      // DURUM 1: 30.50m ÜZERİ
      duvarDk = 120;
      kapakDk = 90;
      mesaj = "Binanız 30.50 metreden yüksek olduğundan tüm tesisat şaft duvarları en az 120 dk, şaft kapakları ise en az 90 dk yangına dayanıklı ve duman sızdırmaz özellikte olmalıdır.";
    } else if (hBinaYonetmelik >= 21.50) {
      // DURUM 2: 21.50m - 30.50m ARASI
      duvarDk = 90;
      kapakDk = 60;
      mesaj = "Binanız 21.50m - 30.50m aralığında olup ‘Yüksek Bina’ sınıfındadır. Tesisat şaftı ve yangın duvarlarınızın en az 90 dk, şaft kapaklarınızın ise en az 60 dk dayanıklı, duman sızdırmaz özellikte olmaları gerekmektedir.";
    } else if (hBodrum >= 10.00) {
      // DURUM 3: ALÇAK BİNA AMA DERİN BODRUM
      duvarDk = 90; // Bodrum esas alındı
      kapakDk = 60; // Bodrum esas alındı
      mesaj = "DİKKAT: Binanız alçak olsa da, bodrum kat derinliğiniz 10 metreyi aştığı için bodrum katlarınız risk taşımaktadır. Bodrumdaki şaft duvarları en az 90 dk ve şaft kapakların dayanımları en az 60dk, zemin üst normal katlarda ise duvarları en az 60dk, kapakları en az 30dk olmalıdır.";
    } else {
      // DURUM 4: STANDART
      duvarDk = 60;
      kapakDk = 30;
      mesaj = "Binanızın yüksekliği ve bodrum derinliği yüksek olmayan bina sınırları içindedir. Tesisat şaft duvarları en az 60 dk, şaft kapakları ise en az 30 dk dayanıklı olması yeterlidir.";
    }

    setState(() {
      _model = Bolum14Model(
        gerekenDuvarDk: duvarDk,
        gerekenKapakDk: kapakDk,
        raporMesaji: mesaj,
      );
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum14 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum15Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Bölüm-14: Tesisat Şaftlarının Durumu",
            subtitle: "...",
            screenType: widget.runtimeType,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // BİLGİ KARTI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.analytics_outlined, size: 40, color: Colors.orange),
                        const SizedBox(height: 10),
                        const Text("GEREKEN YANGIN DAYANIMI", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoBox("Duvar", "${_model.gerekenDuvarDk} dk"),
                            _buildInfoBox("Kapak", "${_model.gerekenKapakDk} dk"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _model.raporMesaji ?? "Hesaplanıyor...",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[800], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Widget _buildInfoBox(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A237E))),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}