import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/bina_store.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/selectable_card.dart';
import '../utils/app_strings.dart';
import 'dashboard_screen.dart';
import 'legal_text_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _kvkkAccepted = false;
  bool _disclaimerAccepted = false;
  String? _selectedProfession;

  final List<String> _professions = [
    'Apartman Sakini',
    'Apartman Yöneticisi / Görevlisi',
    'Proje Mimarı / Mühendisi',
    'Yangın Güvenlik Uzmanı',
    'İSG Uzmanı',
    'İtfaiye / Kamu Personeli',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      if (!_kvkkAccepted || !_disclaimerAccepted) {
        _showError(
          "Devam etmek için yasal bilgilendirmeleri ve kullanım şartlarını onaylamanız gerekmektedir.",
        );
        return;
      }

      BinaStore.instance.userName = _nameController.text;
      BinaStore.instance.userProfession =
          _selectedProfession ?? "Bina Sakini / Vatandaş";
      BinaStore.instance.isRegistered = true;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFFB71C1C)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ModernHeader(
            title: "Yeni Kayıt",
            screenType: RegisterScreen,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      label: "Ad Soyad",
                      icon: Icons.person_outline,
                      controller: _nameController,
                      limit: 40,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: "E-Posta",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      limit: 50,
                      isEmail: true,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField("Meslek / Unvan", Icons.work_outline),
                    const SizedBox(height: 30),
                    const Text(
                      "YASAL ONAYLAR",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildConsentTile(
                      title: AppStrings.kvkkTitle,
                      content:
                          "Verilerimin sadece bu cihazda saklanacağını, sunucuya aktarılmayacağını kabul ediyorum.",
                      value: _kvkkAccepted,
                      onChanged: (val) => setState(() => _kvkkAccepted = val!),
                    ),
                    const SizedBox(height: 12),
                    _buildConsentTile(
                      title: "Kullanım Şartları ve Sorumluluk Reddi",
                      content:
                          "Üretilen belgenin resmi bir rapor olmadığını, saha ziyareti ve Yangın Güvenlik Uzmanı'nın onayı olmadan hukuki geçerliliği bulunmadığını kabul ediyorum.",
                      value: _disclaimerAccepted,
                      onChanged: (val) =>
                          setState(() => _disclaimerAccepted = val!),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LegalTextScreen(),
                          ),
                        ),
                        child: const Text(
                          "Yasal Metinlerin Tamamını Oku",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Color(0xFF1A237E),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required int limit,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      inputFormatters: [LengthLimitingTextInputFormatter(limit)],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Bu alan boş bırakılamaz";
        if (isEmail) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value))
            return "Geçerli bir e-posta adresi giriniz";
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, IconData icon) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _selectedProfession,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
        ),
      ),
      items: _professions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedProfession = newValue;
        });
      },
      validator: (value) => value == null ? "Lütfen bir unvan seçiniz" : null,
      icon: const Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: Color(0xFF1A237E),
      ),
      dropdownColor: const Color(0xFFE8EAF6),
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildConsentTile({
    required String title,
    required String content,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: value ? const Color(0xFFE8EAF6) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? const Color(0xFF1A237E) : Colors.grey.shade200,
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF1A237E),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content,
          style: const TextStyle(fontSize: 11, height: 1.3),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _onRegisterPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "KAYDI TAMAMLA VE BAŞLA",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

