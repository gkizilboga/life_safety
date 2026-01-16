class ActiveSystemRequirement {
  final String name;
  final bool isMandatory;
  final bool isWarning; // NEW
  final String reason;
  final String note;

  ActiveSystemRequirement({
    required this.name,
    required this.isMandatory,
    this.isWarning = false, // NEW
    required this.reason,
    this.note = "",
  });
}
