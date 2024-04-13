import 'package:flutter/material.dart';

class PreviewCharacterTable extends StatelessWidget {
  final Map<String, Image> data;
  PreviewCharacterTable(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 50,
      width: 50,
      //Layering character
      child: Center(
        child: Stack(
          children: [
            data['skin'],
            data['eyeBrows'],
            data['glasses'] != null ? data['glasses'] : data['eyes'],
            data['hair'],
            data['lips'],
          ],
        ),
      ),
    );
  }
}
