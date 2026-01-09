import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/bina_store.dart';
import 'register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Neden Yangın Risk Analizi Yapıyoruz?",
      "desc": "Yangın, sadece bir kaza değil; çoğunlukla yapının mimari eksikliklerinin sonucudur. Bu analiz, binanızdaki gizli riskleri profesyonel bir gözle fark etmenizi sağlar.",
    },
    {
      "title": "36 Adımda Kapsamlı İnceleme",
      "desc": "Binanızı taşıyıcı sistemden kaçış yollarına, asansörlerden tesisat şaftlarına kadar 36 farklı teknik başlıkta titizlikle inceliyoruz.",
    },
    {
      "title": "Yönetmelikle Uyum ve Çözüm Önerileri",
      "desc": "Analiz sonuçlarını Yangın Yönetmeliği (BYKHY) kriterlerine göre yorumluyor ve size özel iyileştirme önerileri sunuyoruz.",
    },
    {
      "title": "Veri Gizliliği ve Güvenlik",
      "desc": "Girdiğiniz tüm teknik veriler ve bina bilgileri sadece bu cihazda saklanır. Hiçbir veri sunucuya aktarılmaz.",
    },
  ];

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
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    BinaStore.instance.hasSeenOnboarding = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) => _buildPageContent(_pages[index]),
                  ),
                ),
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(Map<String, String> page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "YANGIN RİSK ANALİZİ",
            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          const SizedBox(height: 15),
          Text(
            page["title"]!,
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          Text(
            page["desc"]!,
            style: const TextStyle(color: Colors.white60, fontSize: 16, height: 1.6, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) => _buildDot(index)),
          ),
          const SizedBox(height: 30),
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
              onPressed: _currentPage == _pages.length - 1 
                  ? _finishOnboarding 
                  : () => _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease),
              child: Text(
                _currentPage == _pages.length - 1 ? "HEMEN BAŞLA" : "DEVAM ET",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}