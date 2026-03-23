import 'package:flutter/material.dart';
import 'bolum_1_screen.dart';
import '../data/bina_store.dart';
import '../data/turkiye_data.dart';
import 'package:flutter/gestures.dart';
import '../utils/turkish_utils.dart';
import '../utils/app_strings.dart';
import '../widgets/custom_widgets.dart';

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

  @override
  void initState() {
    super.initState();
    // Load existing data if we are editing or going back
    final store = BinaStore.instance;
    if (store.currentBinaName != null) {
      _nameCtrl.text = store.currentBinaName!;
    }
    if (store.currentBinaCity != null) {
      _selectedCity = store.currentBinaCity;
    }
    if (store.currentBinaDistrict != null) {
      _selectedDistrict = store.currentBinaDistrict;
    }
    // Agreement is usually fresh or can be assumed true if we already have a bina id
    if (store.currentBinaId != null) {
      _isAgreed = true;
    }
  }

  List<String> get _cities {
    final cities = TurkiyeData.ilIlceMap.keys.toList();
    cities.sort((a, b) => TurkishUtils.compare(a, b));
    return cities;
  }

  List<String> get _districts {
    if (_selectedCity == null) return [];
    final districts = List<String>.from(TurkiyeData.ilIlceMap[_selectedCity]!);
    districts.sort((a, b) => TurkishUtils.compare(a, b));
    return districts;
  }

  void _start() {
    if (_nameCtrl.text.isEmpty ||
        _selectedCity == null ||
        _selectedDistrict == null) {
      _showSnackBar(
        "Lütfen bina adı, il ve ilçe bilgilerini eksiksiz giriniz.",
      );
      return;
    }
    if (!_isAgreed) {
      _showSnackBar(
        "Lütfen devam etmek için KVKK ve Kullanım Şartlarını onaylayınız.",
      );
      return;
    }

    BinaStore.instance.createNewBuilding(
      name: _nameCtrl.text,
      city: _selectedCity!,
      district: _selectedDistrict!,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Bolum1Screen()),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          const ModernHeader(
            title: "Bina Bilgileri",
            screenType: BuildingSetupScreen,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Bina / Apartman Adı"),
            _buildTextField(_nameCtrl, "Apartman adı giriniz.", Icons.business),

            _buildLabel("İl Seçimi"),
            _buildSearchableDropdown(
              hint: "İl seçiniz",
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
              hint: _selectedCity == null ? "Önce il seçiniz" : "İlçe seçiniz.",
              items: _districts,
              value: _selectedDistrict,
              onChanged: _selectedCity == null
                  ? null
                  : (val) => setState(() => _selectedDistrict = val),
              icon: Icons.location_city,
            ),
            const SizedBox(height: 30),

            _buildKvkkBox(),

            const SizedBox(height: 40),
            _buildStartButton(),
          ],
        ),
      ),
    ),
  ],
),
);
}

  void _showContentDialog(String title, String content) {
    showCustomDialog(
      context: context,
      title: title,
      content: content,
      confirmText: "KAPAT",
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF455A64),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: ctrl,
        maxLength: 40, // Güvenlik: Kaynak tüketimini ve PDF taşmasını önler
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1A237E), size: 22),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
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
    return GestureDetector(
      onTap: onChanged == null
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
                builder: (context) => ListSelector(
                  title: hint,
                  items: items,
                  onSelected: onChanged,
                ),
              );
            },
      child: AbsorbPointer(
        absorbing: true, // Prevents any text input attempts
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: onChanged == null ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onChanged == null
                  ? Colors.grey.shade200
                  : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: onChanged == null
                    ? Colors.grey
                    : const Color(0xFF1A237E),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value ?? hint,
                  style: TextStyle(
                    fontSize: 15,
                    color: value == null
                        ? Colors.grey.shade600
                        : Colors.black87,
                    fontWeight: value == null
                        ? FontWeight.normal
                        : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: onChanged == null
                    ? Colors.grey
                    : const Color(0xFF1A237E).withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKvkkBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isAgreed ? const Color(0xFF1A237E) : const Color(0xFFE0E0E0),
        ),
      ),
      child: CheckboxListTile(
        value: _isAgreed,
        onChanged: (val) => setState(() => _isAgreed = val ?? false),
        activeColor: const Color(0xFF1A237E),
        title: Text.rich(
          TextSpan(
            text:
                "Verilerimin anonim olarak istatistiksel amaçla kullanılmasını, ",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: "Aydınlatma Metni",
                style: const TextStyle(
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _showContentDialog(
                    AppStrings.kvkkTitle,
                    AppStrings.kvkkContent,
                  ),
              ),
              const TextSpan(text: " ve "),
              TextSpan(
                text: "Kullanım Şartlarını",
                style: const TextStyle(
                  color: Color(0xFF1A237E),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _showContentDialog(
                    AppStrings.legalDisclaimerTitle,
                    AppStrings.legalDisclaimerContent,
                  ),
              ),
              const TextSpan(text: " onaylıyorum."),
            ],
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed:
            (_isAgreed && _selectedCity != null && _selectedDistrict != null)
            ? _start
            : null,
        child: const Text(
          "ANALİZİ BAŞLAT",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class ListSelector extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const ListSelector({
    super.key,
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A237E),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  title: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF263238),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    onSelected(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
