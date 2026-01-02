import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'bolum_1_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String buildingName;
  const OnboardingScreen({super.key, required this.buildingName});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/intro_video.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Arka Plan Videosu
          SizedBox.expand(
            child: _controller.value.isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(color: const Color(0xFF1A237E)),
          ),

          // 2. Karartma Katmanı (Okunabilirlik için)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  const Color(0xFF1A237E).withValues(alpha: 0.7),
                  Colors.black.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          // 3. İçerik
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.buildingName.toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Neden Yangın Risk Analizi Yapıyoruz?",
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Yangın, sadece bir kaza değil; çoğunlukla yapının mimari eksikliklerinin sonucudur. Binalarımızdak gizli riskleri ancak profesyonel bir gözle bakıldığında fark edebiliriz. Bu analiz, binanızın Yangın Yönetmeliği 'ne göre mevcut durumunu tespit ederek, olası bir felaketi henüz yaşanmadan önlemeniz için size rehberlik eder. Unutmayın; yangın güvenliği bir lüks değil, yasal ve insani bir zorunluluktur.",
                    style: TextStyle(color: Colors.white38, fontSize: 16, height: 1.6, fontWeight: FontWeight.w400),
                  ),
                  const Spacer(),
                  
                  // Bilgi Satırı
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.timer_outlined, color: Colors.white, size: 24),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Tahmini Analiz Süresi", style: TextStyle(color: Colors.white70, fontSize: 12)),
                              Text("15 - 20 Dakika", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Icon(Icons.assignment_outlined, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // Başlat Butonu
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1A237E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Bolum1Screen()),
                        );
                      },
                      child: const Text(
                        "ANALİZE BAŞLA",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}