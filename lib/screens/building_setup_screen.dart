import 'package:flutter/material.dart';
import 'bolum_1_screen.dart';
import '../data/bina_store.dart';
import '../data/turkiye_data.dart';

class BuildingSetupScreen extends StatefulWidget {
  const BuildingSetupScreen({super.key});

  @override
  State<BuildingSetupScreen> createState() => _BuildingSetupScreenState();
}

class _BuildingSetupScreenState extends State<BuildingSetupScreen> {
  final _nameCtrl = TextEditingController();
  String? _selectedCity;
  String? _selectedDistrict;
  bool _isAgreed = false;

  List<String> get _cities => TurkiyeData.ilIlceMap.keys.toList()..sort();

  List<String> get _districts => _selectedCity != null 
      ? (List<String>.from(TurkiyeData.ilIlceMap[_selectedCity]!)..sort()) 
      : [];

  void _start() {
    if (_nameCtrl.text.isEmpty || _selectedCity == null || _selectedDistrict == null) {
      _showSnackBar("Lütfen bina adı, il ve ilçe bilgilerini eksiksiz giriniz.");
      return;
    }
    if (!_isAgreed) {
      _showSnackBar("Lütfen devam etmek için KVKK ve Kullanım Şartlarını onaylayınız.");
      return;
    }
    
    BinaStore.instance.createNewBuilding(
      name: _nameCtrl.text,
      city: _selectedCity!,
      district: _selectedDistrict!,
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => const Bolum1Screen()));
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Bina Kimlik Bilgileri", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Bina / Apartman Adı"),
            _buildTextField(_nameCtrl, "Örn: Huzur Apartmanı", Icons.business),

            _buildLabel("İl Seçimi"),
            _buildSearchableDropdown(
              hint: "İl seçiniz veya yazınız",
              items: _cities,
              value: _selectedCity,
              onChanged: (val) {
                setState(() {
                  _selectedCity = val;
                  _selectedDistrict = null;
                });
              },
              icon: Icons.map_outlined,
            ),

            const SizedBox(height: 20),

            _buildLabel("İlçe Seçimi"),
            _buildSearchableDropdown(
              hint: _selectedCity == null ? "Önce il seçiniz" : "İlçe seçiniz veya yazınız",
              items: _districts,
              value: _selectedDistrict,
              onChanged: _selectedCity == null ? null : (val) => setState(() => _selectedDistrict = val),
              icon: Icons.location_city,
            ),
            
            const SizedBox(height: 30),
            
            _buildKvkkBox(),

            const SizedBox(height: 40),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF455A64))),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 22),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required void Function(String?)? onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          value: value,
          icon: Icon(Icons.arrow_drop_down_circle_outlined, color: const Color(0xFF1A237E).withValues(alpha: 0.5)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: const Color(0xFF1A237E)),
                  const SizedBox(width: 12),
                  Text(item, style: const TextStyle(fontSize: 15)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildKvkkBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isAgreed ? const Color(0xFF1A237E) : const Color(0xFFE0E0E0)),
      ),
      child: CheckboxListTile(
        value: _isAgreed,
        onChanged: (val) => setState(() => _isAgreed = val ?? false),
        activeColor: const Color(0xFF1A237E),
        title: const Text(
          "Analiz verilerimin anonim olarak istatistiksel amaçla kullanılmasını, Aydınlatma Metni ve Kullanım Şartlarını okudum, onaylıyorum.",
          style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: (_isAgreed && _selectedCity != null && _selectedDistrict != null) ? _start : null,
        child: const Text("ANALİZİ BAŞLAT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}