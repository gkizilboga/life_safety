import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class ActiveSystemsInputDialog extends StatelessWidget {
  final Function(double? parkingArea) onConfirmed;

  const ActiveSystemsInputDialog({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    // Bu dialog artık otopark alanı Bölüm-6'da sorulduğu için kullanılmamaktadır.
    // Ancak kod mimarisini bozmamak adına şimdilik boş bir onay box'ı olarak bırakılabilir
    // veya tetiklendiği yerden kaldırılabilir.
    return CustomAlertDialog(
      title: "Bilgilendirme",
      content: "Aktif sistem analizine hazırsınız.",
      confirmText: "Analizi Göster",
      icon: Icons.info_outline,
    );
  }
}
