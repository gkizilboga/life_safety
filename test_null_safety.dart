
void main() {
  print("Testing null safely...");
  String? label;
  try {
    // This should crash if the theory is correct
    bool result = label.contains("ABC"); 
    print("Result: $result");
  } catch (e) {
    print("Caught expected error: $e");
  }

  // Safe way
  bool safeResult = label?.contains("ABC") ?? false;
  print("Safe Result: $safeResult");
}
