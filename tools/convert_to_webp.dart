import 'dart:io';

/// Basit WebP kopyalayıcı: PNG dosyasını .webp uzantısıyla kopyalar.
/// Flutter asset sistemi PNG içerikli .webp dosyalarını destekler.
/// Kullanım: dart run tools/convert_to_webp.dart kaynak.png hedef.webp
void main(List<String> args) {
  if (args.length < 2) {
    print('Kullanım: dart run tools/convert_to_webp.dart <kaynak.png> <hedef.webp>');
    exit(1);
  }

  final sourcePath = args[0];
  final destPath = args[1];
  final sourceFile = File(sourcePath);

  if (!sourceFile.existsSync()) {
    print('HATA: Kaynak dosya bulunamadı: $sourcePath');
    exit(1);
  }

  print('Kopyalanıyor: $sourcePath -> $destPath');
  sourceFile.copySync(destPath);
  final size = File(destPath).lengthSync();
  print('Başarılı! Hedef dosya: $destPath ($size bytes)');
}
