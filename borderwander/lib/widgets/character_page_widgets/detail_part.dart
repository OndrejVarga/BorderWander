import 'package:flutter/material.dart';

class DetailPart extends StatelessWidget {
  final String title;
  final String data;

  DetailPart(this.title, this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 20),
          ),
          Text(
            data,
            style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 25),
          )
        ],
      ),
    );
  }
}
