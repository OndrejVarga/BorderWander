import 'package:borderwander/providers/image_controller.dart';
import 'package:borderwander/widgets/character_shop_widgets/character_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterChangeWidget extends StatefulWidget {
  @override
  _CharacterChangeWidgetState createState() => _CharacterChangeWidgetState();
}

class _CharacterChangeWidgetState extends State<CharacterChangeWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CharacterOption(Provider.of<ImageController>(context).skinsNames,
                'skin', Provider.of<ImageController>(context).skins, 'Skin'),
            CharacterOption(
                Provider.of<ImageController>(context).eyeBrowsNames,
                'eyeBrows',
                Provider.of<ImageController>(context).eyeBrows,
                'Eyebrows'),
            CharacterOption(Provider.of<ImageController>(context).eyesNames,
                'eyes', Provider.of<ImageController>(context).eyes, 'Eyes'),
            CharacterOption(
                Provider.of<ImageController>(context).glassesNames,
                'glasses',
                Provider.of<ImageController>(context).glasses,
                'Glasses'),
            CharacterOption(Provider.of<ImageController>(context).hairNames,
                'hair', Provider.of<ImageController>(context).hair, 'Hair'),
            CharacterOption(Provider.of<ImageController>(context).lipsNames,
                'lips', Provider.of<ImageController>(context).lips, 'Lips'),
          ],
        ),
      ),
    );
  }
}
