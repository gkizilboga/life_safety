class TurkishUtils {
  static String normalize(String input) {
    if (input.isEmpty) return "";
    return input
        .replaceAll('İ', 'i')
        .replaceAll('I', 'ı')
        .replaceAll('Ş', 'ş')
        .replaceAll('Ğ', 'ğ')
        .replaceAll('Ü', 'ü')
        .replaceAll('Ö', 'ö')
        .replaceAll('Ç', 'ç')
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }

  static int compare(String a, String b) {
    return normalize(a).compareTo(normalize(b));
  }

  static bool contains(String source, String query) {
    return normalize(source).contains(normalize(query));
  }
}
