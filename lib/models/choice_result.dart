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

  factory ChoiceResult.empty() {
    return ChoiceResult(label: '', uiTitle: '', uiSubtitle: '', reportText: '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChoiceResult && other.label == label;
  }

  @override
  int get hashCode => label.hashCode;

  ChoiceResult copyWith({
    String? label,
    String? uiTitle,
    String? uiSubtitle,
    String? reportText,
    String? adviceText,
  }) {
    return ChoiceResult(
      label: label ?? this.label,
      uiTitle: uiTitle ?? this.uiTitle,
      uiSubtitle: uiSubtitle ?? this.uiSubtitle,
      reportText: reportText ?? this.reportText,
      adviceText: adviceText ?? this.adviceText,
    );
  }
}
