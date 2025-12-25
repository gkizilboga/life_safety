import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import 'bolum_5_screen.dart'; // Sonraki ekran
import '../../utils/app_content.dart';

class Bolum4Screen extends StatefulWidget {
  const Bolum4Screen({super.key});

  @override
  State<Bolum4Screen> createState() => _Bolum4ScreenState();
}

class _Bolum4ScreenState extends State<Bolum4Screen> {
  
  @override
  void initState() {
    super.initState();
    // Ekran açılır açılmaz hesaplamayı yap ve diğer ekrana geç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hesaplaVeGec();
    });
  }

  void _hesaplaVeGec() {
    // 1. Bölüm 3 verilerini çek (Zaten hesaplanmış olarak geliyor)
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    // Bölüm 3'te hesaplanan değerleri al
    double hBina = bolum3?.hBina ?? 0.0;
    double hYapi = bolum3?.hYapi ?? 0.0;

    // 2. Risk Analizi (Bölüm 4 Mantığı)
    var secilenSinif = Bolum4Content.yukseklikSinifiDusuk;

    if (hBina >= 51.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiMaksimum;
    } else if (hBina >= 30.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiCokYuksek;
    } else if (hBina >= 21.50) {
      secilenSinif = Bolum4Content.yukseklikSinifiYuksek;
    } else {
      secilenSinif = Bolum4Content.yukseklikSinifiDusuk;
    }

    var secilenUyari = (hYapi > 30.50) ? Bolum4Content.yapiYuksekligiUyari : null;

    // 3. Modeli Oluştur ve Kaydet
    Bolum4Model model = Bolum4Model(
      binaYukseklikSinifi: secilenSinif,
      yapiYuksekligiUyarisi: secilenUyari,
      hesaplananBinaYuksekligi: hBina,
      hesaplananYapiYuksekligi: hYapi,
    );

    BinaStore.instance.bolum4 = model;

    // 4. Hiç beklemeden Bölüm 5'e geç
    // pushReplacement kullanıyoruz ki kullanıcı "Geri" tuşuna basınca bu boş ekrana dönmesin.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kullanıcı çok kısa bir süre (milisaniyeler) bu ekranı görebilir.
    // O yüzden boş bir yükleniyor ekranı gösteriyoruz.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}