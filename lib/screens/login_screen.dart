import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../services/auth_service.dart';
import '../utils/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A365D), // Darker, premium navy
      body: Stack(
        children: [
          // Background Gradient decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "GİRİŞ YAPIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Google Sign In Button
                  _buildGoogleButton(),

                  const SizedBox(height: 30),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "VEYA E-POSTA İLE",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Name & Surname (Optional)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "Ad (İsteğe bağlı)",
                          _nameCtrl,
                          Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInput(
                          "Soyad (İsteğe bağlı)",
                          _surnameCtrl,
                          Icons.person_outline,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Email Input
                  _buildInput(
                    "E-Posta Adresiniz",
                    _emailCtrl,
                    Icons.alternate_email_rounded,
                  ),

                  const SizedBox(height: 20),

                  // Email Login Action
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white24),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleEmailLogin,
                      child: const Text(
                        "DEVAM ET",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
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

  Widget _buildGoogleButton() {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _handleGoogleLogin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_Logo.png', // Temporary network image for branding
              height: 20,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.account_circle),
            ),
            const SizedBox(width: 12),
            const Text(
              "Google Hesabı ile Devam Et",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      final account = await AuthService.signInWithGoogle();
      if (account != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Google Giriş Hatası: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEmailLogin() async {
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen e-posta adresinizi giriniz.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final String fullName =
          "${_nameCtrl.text.trim()} ${_surnameCtrl.text.trim()}".trim();

      await AuthService.signInWithEmail(
        _emailCtrl.text.trim(),
        name: fullName.isNotEmpty ? fullName : null,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildInput(String label, TextEditingController ctrl, IconData icon) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white38),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
