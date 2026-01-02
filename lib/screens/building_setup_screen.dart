import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import '../data/bina_store.dart';

class BuildingSetupScreen extends StatefulWidget {
  const BuildingSetupScreen({super.key});

  @override
  State<BuildingSetupScreen> createState() => _BuildingSetupScreenState();
}

class _BuildingSetupScreenState extends State<BuildingSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  bool _isAgreed = false; // KVKK Onay durumu

  void _start() {
    if (_nameCtrl.text.isEmpty || _cityCtrl.text.isEmpty || _districtCtrl.text.isEmpty) {
      _showSnackBar("Lütfen tüm alanları doldurunuz.");
      return;
    }
    if (!_isAgreed) {
      _showSnackBar("Lütfen kullanım şartlarını ve KVKK metnini onaylayınız.");
      return;
    }
    
    BinaStore.instance.createNewBuilding(
      name: _nameCtrl.text,
      city: _cityCtrl.text,
      district: _districtCtrl.text,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen(buildingName: _nameCtrl.text)));
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(title: const Text("Bina Kimlik Bilgileri"), backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("Bina / Apartman Adı", _nameCtrl, Icons.business),
            _buildField("İl", _cityCtrl, Icons.map_outlined),
            _buildField("İlçe", _districtCtrl, Icons.location_city),
            
            const SizedBox(height: 10),
            
            // --- KVKK VE AYDINLATMA METNİ ALANI ---
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isAgreed ? const Color(0xFF1A237E) : Colors.grey.shade300),
              ),
              child: CheckboxListTile(
                value: _isAgreed,
                onChanged: (val) => setState(() => _isAgreed = val ?? false),
                activeColor: const Color(0xFF1A237E),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                    children: [
                      const TextSpan(text: "Analiz verilerimin anonim olarak istatistiksel amaçla kullanılmasını, "),
                      TextSpan(
                        text: "Aydınlatma Metni",
                        style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        // Buraya ileride tıklama özelliği (TapGestureRecognizer) eklenebilir
                      ),
                      const TextSpan(text: " ve "),
                      TextSpan(
                        text: "Kullanım Şartlarını",
                        style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                      const TextSpan(text: " okudum, onaylıyorum."),
                    ],
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: _isAgreed ? _start : null, // Onaylanmadan buton aktif olmaz
                child: const Text("ANALİZİ BAŞLAT", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}