import 'package:borderwander/providers/image_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CharacterOption extends StatefulWidget {
  @override
  _CharacterOptionState createState() => _CharacterOptionState();
  final String keys;
  final List<Image> images;
  final List<String> names;
  final String name;
  CharacterOption(this.names, this.keys, this.images, this.name);
}

class _CharacterOptionState extends State<CharacterOption> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  if (index - 1 < 0) {
                    index = widget.names.length - 1;
                  } else {
                    index--;
                  }
                  print(widget.names[index]);
                  print(widget.images[index]);

                  Provider.of<ImageController>(context, listen: false)
                      .changeCurrentCharacter(widget.keys, widget.images[index],
                          widget.names[index]);
                });
              },
              child: Icon(
                Icons.arrow_left,
                size: 30,
                color: Colors.white,
              )),
          Container(
            alignment: Alignment.center,
            width: 150,
            child: Text(
              widget.name,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          TextButton(
              onPressed: () async {
                setState(() {
                  if (index + 1 >= widget.names.length) {
                    index = 0;
                  } else {
                    index++;
                  }
                  print(widget.names[index]);
                  print(widget.images[index]);
                  Provider.of<ImageController>(context, listen: false)
                      .changeCurrentCharacter(widget.keys, widget.images[index],
                          widget.names[index]);
                });
              },
              child: Icon(
                Icons.arrow_right,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
