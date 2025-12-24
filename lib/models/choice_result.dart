class ChoiceResult {
  final String label; // A, B, C...
  final String uiTitle; // Ekranda görünen kısa başlık
  final String uiSubtitle; // Ekranda görünen ipucu
  final String reportText; // Raporda çıkacak teknik metin

  ChoiceResult({
    required this.label,
    required this.uiTitle,
    required this.uiSubtitle,
    required this.reportText,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChoiceResult && other.label == label;
  }
  
  @override
  int get hashCode => label.hashCode;
}