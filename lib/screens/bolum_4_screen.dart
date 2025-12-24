import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import 'bolum_5_screen.dart'; // Sonraki ekran
import '../../widgets/custom_widgets.dart';
import '../../widgets/selectable_card.dart';
import '../../utils/app_content.dart';

class Bolum4Screen extends StatefulWidget {
  const Bolum4Screen({super.key});

  @override
  State<Bolum4Screen> createState() => _Bolum4ScreenState();
}

class _Bolum4ScreenState extends State<Bolum4Screen> {
  Bolum4Model _model = Bolum4Model();

  @override
  void initState() {
    super.initState();
    _hesaplaVeAnalizEt();
  }

  void _hesaplaVeAnalizEt() {
    // 1. BinaStore'dan Bölüm 3 verisini çek
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    // Veri yoksa varsayılan değerlerle devam et (Hata almamak için)
    double zeminH = bolum3?.zeminKatYuksekligi ?? 3.50;
    double normalH = bolum3?.normalKatYuksekligi ?? 3.00;
    double bodrumH = bolum3?.bodrumKatYuksekligi ?? 3.50;
    
    // Eğer standart seçildiyse (Model içindeki getter bazen null gelebilir, manuel hesaplıyoruz)
    if (bolum3?.yukseklikTercihi?.label == Bolum3Content.yukseklikStandart.label) {
      zeminH = 3.50;
      normalH = 3.00;
      bodrumH = 3.50;
    }

    int nKat = bolum3?.normalKatSayisi ?? 0;
    int bKat = bolum3?.bodrumKatSayisi ?? 0;

    // HESAPLAMALAR
    // Bina Yüksekliği (H_BİNA): Zemin + Normal Katlar
    double hBina = zeminH + (nKat * normalH);
    
    // Yapı Yüksekliği (H_YAPI): Bodrumlar + Zemin + Normal Katlar
    double hYapi = (bKat * bodrumH) + hBina;

    // ANALİZ (H_BİNA'ya göre)
    // ChoiceResult nesnelerini app_content'ten alıp dinamik metni [H_BINA] ile değiştiriyoruz.
    // Ancak ChoiceResult immutable (değişmez) olduğu için, ekranda gösterirken metni manipüle edeceğiz, 
    // burada sadece doğru nesneyi seçiyoruz.

    var secilenSinif = Bolum4Content.yukseklikSinifiDusuk; // Varsayılan

    if (hBina >= 51.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiMaksimum;
    } else if (hBina >= 30.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiCokYuksek;
    } else if (hBina >= 21.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiYuksek;
    } else {
      secilenSinif = Bolum4Content.yukseklikSinifiDusuk;
    }

    // ANALİZ (H_YAPI'ya göre - Bodrumlu Yükseklik)
    var secilenUyari = (hYapi > 30.50) ? Bolum4Content.yapiYuksekligiUyari : null;

    setState(() {
      _model = Bolum4Model(
        binaYukseklikSinifi: secilenSinif,
        yapiYuksekligiUyarisi: secilenUyari,
        hesaplananBinaYuksekligi: hBina,
        hesaplananYapiYuksekligi: hYapi,
      );
    });
  }

  void _onNextPressed() {
    BinaStore.instance.bolum4 = _model;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ModernHeader(
            title: "Bölüm-4: Yükseklik Analizi",
            subtitle: "Sistem tarafından hesaplanan risk durumu.",
            currentStep: 4,
            totalSteps: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // BİLGİLENDİRME KARTI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text("HESAPLANAN BİNA YÜKSEKLİĞİ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(height: 5),
                        Text(
                          "${_model.hesaplananBinaYuksekligi?.toStringAsFixed(2)} metre",
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1A237E)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  QuestionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tespit Edilen Yangın Sınıfı:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        
                        // ANA SINIF KARTI
                        if (_model.binaYukseklikSinifi != null)
                          SelectableCard(
                            choice: _model.binaYukseklikSinifi!,
                            isSelected: true, // Bilgi amaçlı olduğu için seçili gösteriyoruz
                            onTap: () {}, // Tıklanınca bir şey yapmasına gerek yok
                          ),

                        // VARSA BODRUM UYARISI
                        if (_model.yapiYuksekligiUyarisi != null) ...[
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          const Text("Ek Yapı Uyarısı:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                          const SizedBox(height: 10),
                          SelectableCard(
                            choice: _model.yapiYuksekligiUyarisi!,
                            isSelected: true,
                            onTap: () {},
                          ),
                        ]
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
                  child: const Text("ANALİZE DEVAM ET"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}