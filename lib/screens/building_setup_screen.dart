import 'package:flutter/material.dart';
import 'bolum_1_screen.dart';
import '../data/bina_store.dart';
import '../data/turkiye_data.dart';
import '../utils/turkish_utils.dart';

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
      appBar: AppBar(
        title: const Text(
          "Bina Bilgileri",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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
                builder: (context) => SearchableListSelector(
                  title: hint,
                  items: items,
                  onSelected: onChanged,
                ),
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
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
              color: onChanged == null ? Colors.grey : const Color(0xFF1A237E),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 15,
                  color: value == null ? Colors.grey : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.search,
              size: 18,
              color: const Color(0xFF1A237E).withValues(alpha: 0.5),
            ),
          ],
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
        title: const Text(
          "Verilerimin anonim olarak istatistiksel amaçla kullanılmasını, Aydınlatma Metni ve Kullanım Şartlarını onaylıyorum.",
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

class SearchableListSelector extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const SearchableListSelector({
    super.key,
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  State<SearchableListSelector> createState() => _SearchableListSelectorState();
}

class _SearchableListSelectorState extends State<SearchableListSelector> {
  final _searchCtrl = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchCtrl.addListener(_filter);
  }

  void _filter() {
    final query = _searchCtrl.text;
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => TurkishUtils.contains(item, query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "Ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    widget.onSelected(item);
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
