class ChoiceResult {
  final String label;
  final String uiTitle;
  final String uiSubtitle;
  final String reportText;
  final String? adviceText;

  ChoiceResult({
    required this.label,
    required this.uiTitle,
    required this.uiSubtitle,
    required this.reportText,
    this.adviceText,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChoiceResult && other.label == label;
  }
  
  @override
  int get hashCode => label.hashCode;
}