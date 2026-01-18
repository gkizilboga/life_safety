import 'package:flutter/material.dart';

class ActiveSystemsInputDialog extends StatelessWidget {
  final Function(double? parkingArea) onConfirmed;

  const ActiveSystemsInputDialog({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    // Bu dialog artık otopark alanı Bölüm-6'da sorulduğu için kullanılmamaktadır.
    // Ancak kod mimarisini bozmamak adına şimdilik boş bir onay box'ı olarak bırakılabilir
    // veya tetiklendiği yerden kaldırılabilir.
    return AlertDialog(
      title: const Text("Bilgilendirme"),
      content: const Text("Aktif sistem analizine hazırsınız."),
      actions: [
        ElevatedButton(
          onPressed: () {
            onConfirmed(null);
            Navigator.pop(context);
          },
          child: const Text("Analizi Göster"),
        ),
      ],
    );
  }
}
