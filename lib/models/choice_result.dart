enum RiskLevel { critical, warning, positive, unknown, info }

/// Priority mapping for risk level comparison.
/// critical=4 (highest) > warning=3 > unknown=2 > positive=1 > info=0 (lowest)
extension RiskLevelPriority on RiskLevel {
  int get priority {
    switch (this) {
      case RiskLevel.critical:
        return 4;
      case RiskLevel.warning:
        return 3;
      case RiskLevel.unknown:
        return 2;
      case RiskLevel.positive:
        return 1;
      case RiskLevel.info:
        return 0;
    }
  }
}

class ChoiceResult {
  final String label;
  final String uiTitle;
  final String uiSubtitle;
  final String reportText;
  final String? adviceText;
  final RiskLevel level;

  ChoiceResult({
    required this.label,
    required this.uiTitle,
    required this.uiSubtitle,
    required this.reportText,
    this.adviceText,
    this.level = RiskLevel.positive,
  });

  factory ChoiceResult.empty() {
    return ChoiceResult(
      label: '',
      uiTitle: '',
      uiSubtitle: '',
      reportText: '',
      level: RiskLevel.unknown,
    );
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
    RiskLevel? level,
  }) {
    return ChoiceResult(
      label: label ?? this.label,
      uiTitle: uiTitle ?? this.uiTitle,
      uiSubtitle: uiSubtitle ?? this.uiSubtitle,
      reportText: reportText ?? this.reportText,
      adviceText: adviceText ?? this.adviceText,
      level: level ?? this.level,
    );
  }
}
