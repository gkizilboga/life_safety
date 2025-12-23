import 'package:life_safety/models/bolum_13_model.dart'; // ChoiceResult için

class Bolum22Model {
  ChoiceResult? resItfaiyeAsansorVar;
  ChoiceResult? resItfaiyeAsansorYeri;
  ChoiceResult? resYghBoyut;
  ChoiceResult? resItfaiyeTeknikKabin;
  ChoiceResult? resItfaiyeTeknikEnerji;
  ChoiceResult? resItfaiyeTeknikBasinc;

  Bolum22Model({
    this.resItfaiyeAsansorVar,
    this.resItfaiyeAsansorYeri,
    this.resYghBoyut,
    this.resItfaiyeTeknikKabin,
    this.resItfaiyeTeknikEnerji,
    this.resItfaiyeTeknikBasinc,
  });

  Bolum22Model copyWith({
    ChoiceResult? resItfaiyeAsansorVar,
    ChoiceResult? resItfaiyeAsansorYeri,
    ChoiceResult? resYghBoyut,
    ChoiceResult? resItfaiyeTeknikKabin,
    ChoiceResult? resItfaiyeTeknikEnerji,
    ChoiceResult? resItfaiyeTeknikBasinc,
  }) {
    return Bolum22Model(
      resItfaiyeAsansorVar: resItfaiyeAsansorVar ?? this.resItfaiyeAsansorVar,
      resItfaiyeAsansorYeri: resItfaiyeAsansorYeri ?? this.resItfaiyeAsansorYeri,
      resYghBoyut: resYghBoyut ?? this.resYghBoyut,
      resItfaiyeTeknikKabin: resItfaiyeTeknikKabin ?? this.resItfaiyeTeknikKabin,
      resItfaiyeTeknikEnerji: resItfaiyeTeknikEnerji ?? this.resItfaiyeTeknikEnerji,
      resItfaiyeTeknikBasinc: resItfaiyeTeknikBasinc ?? this.resItfaiyeTeknikBasinc,
    );
  }
}