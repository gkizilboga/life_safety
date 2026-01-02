import 'package:flutter/material.dart';
import '../../data/bina_store.dart';
import '../../models/bolum_3_model.dart';
import '../../models/bolum_4_model.dart';
import 'bolum_5_screen.dart'; 
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hesaplaVeGec();
    });
  }

  void _hesaplaVeGec() {
    final Bolum3Model? bolum3 = BinaStore.instance.bolum3;
    
    double hBina = bolum3?.hBina ?? 0.0;
    double hYapi = bolum3?.hYapi ?? 0.0;

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

    Bolum4Model model = Bolum4Model(
      binaYukseklikSinifi: secilenSinif,
      yapiYuksekligiUyarisi: secilenUyari,
      hesaplananBinaYuksekligi: hBina,
      hesaplananYapiYuksekligi: hYapi,
    );

    BinaStore.instance.bolum4 = model;
    BinaStore.instance.saveToDisk();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Bolum5Screen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF1A237E),
              strokeWidth: 3,
            ),
            SizedBox(height: 20),
            Text(
              "Yükseklik Analizi Yapılıyor...",
              style: TextStyle(
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}