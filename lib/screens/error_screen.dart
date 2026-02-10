import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_theme.dart';

class ErrorScreen extends StatefulWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRestart;

  const ErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRestart,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                "Bir Hata Oluştu",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Beklenmedik bir sorunla karşılaştık. Uygulamanın verileri korunmaktadır. Lütfen uygulamayı yeniden başlatmayı deneyin.",
                style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed:
                    widget.onRestart ??
                    () {
                      // Fallback restart: Pop everything and go to root
                      if (Navigator.canPop(context)) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                        // In a real app we might use Phoenix or similar to full restart
                        // For now, let's try to just trigger a rebuild or navigation
                      }
                    },
                icon: const Icon(Icons.refresh),
                label: const Text("Uygulamayı Yeniden Başlat"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showDetails = !_showDetails;
                  });
                },
                child: Text(
                  _showDetails
                      ? "Hata Detaylarını Gizle"
                      : "Hata Detaylarını Göster",
                ),
              ),
              if (_showDetails) ...[
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        "${widget.error}\n\n${widget.stackTrace ?? ''}",
                        style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: "${widget.error}\n\n${widget.stackTrace ?? ''}",
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Hata detayları kopyalandı"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text("Hatayı Kopyala"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
