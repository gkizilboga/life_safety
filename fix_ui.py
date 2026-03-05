import os

file_path = "lib/screens/bolum_16_screen.dart"

with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

# We want to replace lines 312 to 410 with our new Column block.
# Lines are 0-indexed in python list. So line 313 -> index 312.
# We will replace from index 312 (child: Form...) to index 409 ( ), )

new_block = """              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Binanızın en uzun cephesinin uzunluğu ne kadardır?",
                    style: AppStyles.questionTitle,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "İtfaiye su verme bağlantısı (> 75m) zorunluluğu için bu bilgi gereklidir.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguOlumlu,
                    isSelected: _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguOlumlu.label,
                    onTap: () => setState(() => _model = _model.copyWith(
                          cepheUzunlugu: Bolum16Content.cepheUzunluguOlumlu,
                        )),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguKritik,
                    isSelected: _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguKritik.label,
                    onTap: () => setState(() => _model = _model.copyWith(
                          cepheUzunlugu: Bolum16Content.cepheUzunluguKritik,
                        )),
                  ),
                  SelectableCard(
                    choice: Bolum16Content.cepheUzunluguBilinmiyor,
                    isSelected: _model.cepheUzunlugu?.label ==
                        Bolum16Content.cepheUzunluguBilinmiyor.label,
                    onTap: () => setState(() => _model = _model.copyWith(
                          cepheUzunlugu: Bolum16Content.cepheUzunluguBilinmiyor,
                        )),
                  ),
                ],
              ),
"""

lines[312:410] = [new_block]

with open(file_path, "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Replacement successful")
