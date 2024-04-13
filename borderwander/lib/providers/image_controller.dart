import 'dart:convert';
import 'package:flutter/material.dart';

class ImageController with ChangeNotifier {
  List<Image> skins = [],
      eyeBrows = [],
      eyes = [],
      glasses = [],
      hair = [],
      lips = [],
      tShirts = [];

  List<String> skinsNames = [],
      eyeBrowsNames = [],
      eyesNames = [],
      glassesNames = [],
      hairNames = [],
      lipsNames = [],
      tShirtsNames = [];

  List<String> _allKeys = [];
  Map<String, Image> _currentCharacter = {};
  Map<String, String> _currentCharacterName = {};

  Map<String, Image> get currentCharacter => _currentCharacter;
  List<String> get toDatabase {
    return [
      _currentCharacterName['skin'],
      _currentCharacterName['eyeBrows'],
      _currentCharacterName['eyes'],
      _currentCharacterName['glasses'],
      _currentCharacterName['hair'],
      _currentCharacterName['lips']
    ];
  }

  Map<String, Image> fromNamesToTable(List<String> names) {
    return {
      'skin': skins[skinsNames.indexOf(names[0])],
      'eyeBrows': eyeBrows[eyeBrowsNames.indexOf(names[1])],
      'eyes': eyes[eyesNames.indexOf(names[2])],
      'glasses': glasses[glassesNames.indexOf(names[3])],
      'hair': hair[hairNames.indexOf(names[4])],
      'lips': lips[lipsNames.indexOf(names[5])]
    };
  }

  void fromNames(List<String> names) {
    print(names);
    print(skinsNames);
    _currentCharacter['skin'] = skins[skinsNames.indexOf(names[0])];
    _currentCharacter['eyeBrows'] = eyeBrows[eyeBrowsNames.indexOf(names[1])];
    _currentCharacter['eyes'] = eyes[eyesNames.indexOf(names[2])];
    _currentCharacter['glasses'] = glasses[glassesNames.indexOf(names[3])];
    _currentCharacter['hair'] = hair[hairNames.indexOf(names[4])];
    _currentCharacter['lips'] = lips[lipsNames.indexOf(names[5])];

    _currentCharacterName['skin'] = names[0];
    _currentCharacterName['eyeBrows'] = names[1];
    _currentCharacterName['eyes'] = names[2];
    _currentCharacterName['glasses'] = names[3];
    _currentCharacterName['hair'] = names[4];
    _currentCharacterName['lips'] = names[5];
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    print('starting');
    var manifestMap = json.decode(
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json'));
    List<String> imageKeys = manifestMap.keys.toList();
    _allKeys = imageKeys
        .where((element) => element.contains('assets/character'))
        .toList();
    List<dynamic> temp = [];
    temp = setCharacter('skin');
    skins = temp[0];
    skinsNames = temp[1];

    temp = setCharacter('eye_brows');
    eyeBrows = temp[0];
    eyeBrowsNames = temp[1];

    temp = setCharacter('eyes');
    eyes = temp[0];
    eyesNames = temp[1];

    temp = setCharacter('glasses');
    glasses = temp[0];
    glasses.add(null);
    glassesNames = temp[1];
    glassesNames.add('none');

    temp = setCharacter('hair');
    hair = temp[0];
    hairNames = temp[1];

    temp = setCharacter('lips');
    lips = temp[0];
    lipsNames = temp[1];

    temp = setCharacter('t_shirt');
    tShirts = temp[0];
    tShirtsNames = temp[1];

    _currentCharacter = {
      'skin': skins[0],
      'eyeBrows': eyeBrows[0],
      'eyes': eyes[0],
      'glasses': glasses[0],
      'hair': hair[0],
      'lips': lips[0],
      'tShirts': tShirts[0],
    };
    _currentCharacterName = {
      'skin': skinsNames[0],
      'eyeBrows': eyeBrowsNames[0],
      'eyes': eyesNames[0],
      'glasses': glassesNames[0],
      'hair': hairNames[0],
      'lips': lipsNames[0],
      'tShirts': tShirtsNames[0],
    };
  }

  List<dynamic> setCharacter(String folder) {
    List<Image> images = [];
    List<String> names = [];
    List<String> skinsKeys = _allKeys.where((element) {
      return element.contains('assets/character/$folder');
    }).toList();

    for (int i = 0; i < skinsKeys.length; i++) {
      images.add(Image.asset(skinsKeys[i]));
      String name = skinsKeys[i]
          .substring(
              'assets/character/$folder/'.length, skinsKeys[i].length - 4)
          .replaceAll('_', ' ');
      names.add(name);
    }

    return [images, names];
  }

  void changeCurrentCharacter(String key, Image imgs, String name) {
    _currentCharacter[key] = imgs;
    _currentCharacterName[key] = name;
    notifyListeners();
  }
}
