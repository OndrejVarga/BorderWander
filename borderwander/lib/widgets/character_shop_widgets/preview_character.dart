import 'package:borderwander/providers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviewCharacter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(100)),
      //Layering character
      child: Center(
        child: Stack(
          children: [
            Provider.of<ImageController>(context).currentCharacter['skin'],
            Provider.of<ImageController>(context).currentCharacter['eyeBrows'],
            Provider.of<ImageController>(context).currentCharacter['glasses'] !=
                    null
                ? Provider.of<ImageController>(context)
                    .currentCharacter['glasses']
                : Provider.of<ImageController>(context)
                    .currentCharacter['eyes'],
            Provider.of<ImageController>(context).currentCharacter['hair'],
            Provider.of<ImageController>(context).currentCharacter['lips'],
          ],
        ),
      ),
    );
  }
}
