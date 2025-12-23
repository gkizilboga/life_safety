import 'package:flutter/material.dart';
import 'package:life_safety/data/bina_store.dart';
import 'package:life_safety/models/bolum_13_model.dart';
import 'package:life_safety/models/bolum_25_model.dart';
import 'package:life_safety/widgets/custom_widgets.dart';
import 'package:life_safety/screens/bolum_26_screen.dart';

class Bolum25Screen extends StatefulWidget {
  const Bolum25Screen({super.key});

  @override
  State<Bolum25Screen> createState() => _Bolum25ScreenState();
}

class _Bolum25ScreenState extends State<Bolum25Screen> {
  Bolum25Model _model = Bolum25Model();
  bool _isSkipped = false;

  @override
  void initState() {
    super.initState();
    
    final int donerMerdivenSayisi = BinaStore.instance.bolum20?.cntDonerMerdiven ?? 0;
    final bool isLimit0950 = BinaStore.instance.bolum4?.isLimitBina0950 ?? false;

    // KOŞUL: Döner merdiven YOKSA veya Bina 9.50m'den YÜKSEKSE bu bölümü atla.
    // (Yönetmelik: 9.50m üzeri binalarda döner merdiven kaçış yolu olamaz, bu yüzden detay sormaya gerek yoktur veya başka bir mantıkla reddedilir. 
    // Talimata göre: is_limit_bina_0950 == false ise çalıştır.)
    
    if (donerMerdivenSayisi == 0 || isLimit0950 == true) {
      _isSkipped = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onNextPressed(); 
      });
    }

    if (BinaStore.instance.bolum25 != null) {
      _model = BinaStore.instance.bolum25!;
    }
  }

  void _onNextPressed() {
    if (!_isSkipped) {
      BinaStore.instance.bolum25 = _model;
      print("Bölüm 25 Kaydedildi.");
    } else {
      print("Bölüm 25 Atlandı (Koşullar sağlanmadı).");
    }
Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum26Screen()));
    
    // Şimdilik geçici son mesaj
    if (!_isSkipped) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bölüm 25 Tamamlandı.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSkipped) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          ModernHeader(
            title: "Dairesel Merdiven",
            subtitle: "Bölüm 25: Döner Merdiven Şartları",
            currentStep: 25,
            totalSteps: 25, // Tahmini
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DAİRESEL (DÖNER) MERDİVEN KONTROLÜ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Binanızda döner merdiven bulunduğu ve bina yüksekliği 9.50m sınırının altında olduğu için aşağıdaki şartlar sağlanmalıdır.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 25),

                  // ADIM-1
                  const Text("ADIM-1: KULLANICI YÜKÜ VE GENİŞLİK", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Mevcut döner merdiveninizin genişliği ve en kalabalık katta hizmet ettiği kişi sayısı nedir?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Genişlik < 100 cm VEYA Kişi > 25.",
                          subtitle: "🚨 KIRMIZI RİSK: Kaçış yolu sayılamaz.",
                          value: ChoiceResult(label: "A", reportText: "🚨 KIRMIZI RİSK. Döner merdivenler 'Zorunlu Çıkış' olarak kabul edilebilmesi için en az 100 cm genişlikte olmalı ve en fazla 25 kişiye hizmet etmelidir."),
                          groupValue: _model.resDonerGenislikYuk,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerGenislikYuk: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Genişlik ≥ 100 cm VE Kişi ≤ 25.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "B", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resDonerGenislikYuk,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerGenislikYuk: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-2
                  const Divider(height: 40),
                  const Text("ADIM-2: BASAMAK GENİŞLİĞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Döner merdiven basamaklarına bastığınızda, ayağınızın tam sığdığı (geniş) kısım yeterli mi?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Evet, rahat basılıyor.",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR (Ortalarda 25cm)",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resDonerBasamak,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerBasamak: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Hayır, basamaklar çok dar.",
                          subtitle: "⚠️ UYARI: Düşme riski.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Döner merdivenlerde basamak genişliği, merkezden 50 cm uzaklıkta en az 25 cm olmalıdır."),
                          groupValue: _model.resDonerBasamak,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerBasamak: val)),
                        ),
                      ],
                    ),
                  ),

                  // ADIM-3
                  const Divider(height: 40),
                  const Text("ADIM-3: BAŞ KURTARMA YÜKSEKLİĞİ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 8),
                  const Text("Merdivenden inerken üstteki basamak veya tavan başınıza ne kadar yakın?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 15),
                  QuestionCard(
                    child: Column(
                      children: [
                        SelectableCard<ChoiceResult>(
                          title: "A) Ferah (2.50 metreden yüksek).",
                          subtitle: "✅ OLUMLU GÖRÜNÜYOR",
                          value: ChoiceResult(label: "A", reportText: "✅ OLUMLU GÖRÜNÜYOR"),
                          groupValue: _model.resDonerBasKurtarma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerBasKurtarma: val)),
                        ),
                        SelectableCard<ChoiceResult>(
                          title: "B) Standart (2.10 - 2.50 metre arası).",
                          subtitle: "⚠️ UYARI: Baş çarpma riski.",
                          value: ChoiceResult(label: "B", reportText: "⚠️ UYARI. Döner merdivenlerde baş kurtarma yüksekliği, normal merdivenlerden daha fazla (en az 2.50 m) olmalıdır."),
                          groupValue: _model.resDonerBasKurtarma,
                          onChanged: (val) => setState(() => _model = _model.copyWith(resDonerBasKurtarma: val)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
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
            child: const Text("DEVAM ET"),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    if (_isSkipped) return true;
    if (_model.resDonerGenislikYuk == null) return false;
    if (_model.resDonerBasamak == null) return false;
    if (_model.resDonerBasKurtarma == null) return false;
    return true;
  }
}