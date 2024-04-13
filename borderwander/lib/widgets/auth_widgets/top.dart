import 'package:flutter/material.dart';

class AuthTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Thouse nice Circles at the top of the screen in Login and Register
    return Container(
      width: 500,
      height: 250,
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 500,
              height: 250,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
          Positioned(
            top: -64,
            left: 204,
            child: Container(
              width: 285,
              height: 286,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(285, 286)),
              ),
            ),
          ),
          Positioned(
            top: 44,
            left: -54,
            child: Container(
              width: 175,
              height: 178,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.all(Radius.elliptical(175, 178)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
